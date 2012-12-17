require_relative 'edge'

module Geometry

=begin rdoc
A {Polyline} is like a {Polygon} in that it only contains straight lines, but
also like a {Path} in that it isn't necessarily closed.

{http://en.wikipedia.org/wiki/Polyline}

== Usage

=end

    class Polyline
	attr_reader :edges, :vertices

	# Construct a new Polyline from Points and/or Edges
	#  The constructor will try to convert all of its arguments into {Point}s and
	#   {Edge}s. Then successive {Point}s will be collpased into {Edge}s. Successive
	#   {Edge}s that share a common vertex will be added to the new {Polyline}. If
	#   there's a gap between {Edge}s it will be automatically filled with a new
	#   {Edge}.
	# @overload initialize(Edge, Edge, ...)
	#   @return [Polyline]
	# @overload initialize(Point, Point, ...)
	#   @return [Polyline]
	def initialize(*args)
	    args.map! {|a| (a.is_a?(Array) || a.is_a?(Vector)) ? Point[a] : a}
	    args.each {|a| raise ArgumentError, "Unknown argument type #{a.class}" unless a.is_a?(Point) or a.is_a?(Edge) }

	    @edges = [];
	    @vertices = [];

	    first = args.shift
	    if first.is_a?(Point)
		@vertices.push first
	    elsif first.is_a?(Edge)
		@edges.push first
		@vertices.push *(first.to_a)
	    end

	    args.reduce(@vertices.last) do |previous,n|
		if n.is_a?(Point)
		    if n == previous	# Ignore repeated Points
			previous
		    else
			if @edges.last
			    new_edge = Edge.new(previous, n)
			    if @edges.last.parallel?(new_edge)
				popped_edge = @edges.pop		# Remove the previous Edge
				@vertices.pop(@edges.size ? 1 : 2)	# Remove the now unused vertex, or vertices
				if n == popped_edge.first
				    popped_edge.first
				else
				    push_edge Edge.new(popped_edge.first, n)
				    push_vertex popped_edge.first
				    push_vertex n
				    n
				end
			    else
				push_edge Edge.new(previous, n)
				push_vertex n
				n
			    end
			else
			    push_edge Edge.new(previous, n)
			    push_vertex n
			    n
			end
		    end
		elsif n.is_a?(Edge)
		    if previous == n.first
			push_edge n
			push_vertex n.last
		    elsif previous == n.last
			push_edge n.reverse!
			push_vertex n.last
		    else
			e = Edge.new(previous, n.first)
			push_edge e, n
			push_vertex *(e.to_a), *(n.to_a)
		    end
		    n.last
		end
	    end
	end

	# Check the equality of two {Polyline}s. Note that if two {Polyline}s have
	#  opposite winding, but are otherwise identical, they will be considered unequal.
	# @return [Bool] true if both {Polyline}s have equal edges
	def eql?(other)
	    @vertices.zip(other.vertices).all? {|a,b| a == b}
	end
	alias :== :eql?

	# Offset the receiver by the specified distance. A positive distance
	#  will offset to the left, and a negative distance to the right.
	# @param [Number] distance	The distance to offset by
	# @return [Polygon] A new {Polygon} outset by the given distance
	def offset(distance)
	    bisectors = offset_bisectors(distance)
	    offsets = bisectors.each_cons(2).to_a

	    # Create the offset edges and then wrap them in Hashes so the edges
	    #  can be altered while walking the array
	    active_edges = edges.zip(offsets).map do |e,offset|
		offset = Edge.new(e.first+offset.first.vector, e.last+offset.last.vector)

		# Skip zero-length edges
		{:edge => (offset.first == offset.last) ? nil : offset}
	    end

	    # Walk the array and handle any intersections
	    for i in 0..(active_edges.count-1) do
		e1 = active_edges[i][:edge]
		next unless e1	# Ignore deleted edges

		intersection, j = find_last_intersection(active_edges, i, e1)
		if intersection
		    e2 = active_edges[j][:edge]
		    if intersection.is_a? Point
			active_edges[i][:edge] = Edge.new(e1.first, intersection)
			active_edges[j][:edge] = Edge.new(intersection, e2.last)
		    else
			# Handle the collinear case
			active_edges[i][:edge] = Edge.new(e1.first, e2.last)
			active_edges[j].delete(:edge)
		    end

		    # Delete everything between e1 and e2
		    for k in i..j do
			next if (k==i) or (k==j)    # Exclude e1 and e2
			active_edges[k].delete(:edge)
		    end

		    redo    # Recheck the modified edges
		end
	    end
	    Polyline.new *(active_edges.map {|e| e[:edge]}.compact.map {|e| [e.first, e.last]}.flatten)
	end
	alias :leftset :offset

	# Rightset the receiver by the specified distance
	# @param [Number] distance	The distance to offset by
	# @return [Polygon] A new {Polygon} rightset by the given distance
	def rightset(distance)
	    offset(-distance)
	end

	private

	# @group Helpers for offset()

	# Vertex bisectors suitable for offsetting
	# @param [Number] length    The distance to offset by
	# @return [Array<Edge>]	{Edge}s representing the bisectors
	def offset_bisectors(length)
	    vectors = edges.map {|e| e.direction }
	    winding = 0
	    sums = vectors.unshift(vectors.first).push(vectors.last).each_cons(2).map do |v1,v2|
		k = v1[0]*v2[1] - v1[1]*v2[0]	# z-component of v1 x v2
		winding += k
		if v1 == v2			# collinear, same direction?
		    Vector[-v1[1], v1[0]]
		elsif 0 == k			# collinear, reverse direction
		    nil
		else
		    by = (v2[1] - v1[1])/k
		    v = (0 == v1[1]) ? v2 : v1
		    Vector[(v[0]*by - 1)/v[1], by]
		end
	    end

	    vertices.zip(sums).map {|v,b| b ? Edge.new(v, v+(b * length)) : nil}
	end

	# Find the next edge that intersects with e, starting at index i
	def find_next_intersection(edges, i, e)
	    for j in i..(edges.count-1)
		e2 = edges[j][:edge]
		next if !e2 || e.connected?(e2)
		intersection = e.intersection(e2)
		return [intersection, j] if intersection
	    end
	    nil
	end

	# Find the last edge that intersects with e, starting at index i
	def find_last_intersection(edges, i, e)
	    intersection, intersection_at = nil, nil
	    for j in i..(edges.count-1)
		e2 = edges[j][:edge]
		next if !e2 || e.connected?(e2)
		_intersection = e.intersection(e2)
		intersection, intersection_at = _intersection, j if _intersection
	    end
	    [intersection, intersection_at]
	end
	# @endgroup

	def push_edge(*e)
	    @edges.push *e
	    @edges.uniq!
	end

	def push_vertex(*v)
	    @vertices.push *v
	    @vertices.uniq!
	end
    end
end
