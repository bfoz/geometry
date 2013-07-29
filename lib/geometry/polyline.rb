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

	# Check to see if the {Polyline} is closed (ie. is it a {Polygon}?)
	# @return [Bool] true if the {Polyline} is closed (the first vertex is equal to the last vertex)
	def closed?
	    @edges.last.last == @edges.first.first
	end

	# @group Bisectors

	# Generate the angle bisector unit vectors for each vertex
	# @note If the {Polyline} isn't closed (the normal case), then the first and
	#   last vertices will be given bisectors that are perpendicular to themselves.
	# @return [Array<Vector>]   the unit {Vector}s representing the angle bisector of each vertex
	def bisectors
	    # Multiplying each bisector by the sign of k flips any bisectors that aren't pointing towards the interior of the angle
	    bisector_map {|b, k| k <=> 0 }
	end

	# Generate left angle bisector unit vectors for each vertex
	# @note This is similar to the #bisector method, but generates vectors that always point to the left side of the {Polyline} instead of towards the inside of each corner
	# @return [Array<Vector>]   the unit {Vector}s representing the left angle bisector of each vertex
	def left_bisectors
	    bisector_map
	end

	# @endgroup Bisectors

	# @param [Number] distance	The distance to offset by
	# @return [Polygon] A new {Polygon} outset by the given distance
	def offset(distance)
	    bisector_pairs = if closed?
		bisector_edges = offset_bisectors(distance)
		bisector_edges.push(bisector_edges.first).each_cons(2)
	    else
		offset_bisectors(distance).each_cons(2)
	    end

	    # Create the offset edges and then wrap them in Hashes so the edges
	    #  can be altered while walking the array
	    active_edges = edges.zip(bisector_pairs).map do |e,offset|
		offset_edge = Edge.new(e.first+offset.first.vector, e.last+offset.last.vector)

		# Skip zero-length edges
		{:edge => (offset_edge.first == offset_edge.last) ? nil : offset_edge}
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

	# Generate bisectors and k values with an optional mapping block
	# @note If the {Polyline} isn't closed (the normal case), then the first and
	#   last vertices will be given bisectors that are perpendicular to themselves.
	# @return [Array<Vector>]   the unit {Vector}s representing the angle bisector of each vertex
	def bisector_map
	    winding = 0
	    tangent_loop.each_cons(2).map do |v1,v2|
		k = v1[0]*v2[1] - v1[1]*v2[0]	# z-component of v1 x v2
		winding += k
		if v1 == v2			# collinear, same direction?
		    Vector[-v1[1], v1[0]]
		elsif 0 == k			# collinear, reverse direction
		    nil
		else
		    bisector_y = (v2[1] - v1[1])/k
		    v = (0 == v1[1]) ? v2 : v1
		    bisector = Vector[(v[0]*bisector_y - 1)/v[1], bisector_y]
		    block_given? ? (bisector * yield(bisector, k)) : bisector
		end
	    end
	end

	# @group Helpers for offset()

	# Vertex bisectors suitable for offsetting
	# @param [Number] length    The distance to offset by. Positive generates left offset bisectors, negative generates right offset bisectors
	# @return [Array<Edge>]	{Edge}s representing the bisectors
	def offset_bisectors(length)
	    vertices.zip(left_bisectors).map {|v,b| b ? Edge.new(v, v+(b * length)) : nil}
	end

	# Generate the tangents and fake a circular buffer while accounting for closedness
	# @return [Array<Vector>]   the tangents
	def tangent_loop
	    edges.map {|e| e.direction }.tap do |tangents|
		# Generating a bisector for each vertex requires an edge on both sides of each vertex.
		# Obviously, the first and last vertices each have only a single adjacent edge, unless the
		# Polyline happens to be closed (like a Polygon). When not closed, duplicate the
		# first and last direction vectors to fake the adjacent edges. This causes the first and last
		# edges to have bisectors that are perpendicular to themselves.
		if closed?
		    # Prepend the last direction vector so that the last edge can be used to find the bisector for the first vertex
		    tangents.unshift tangents.last
		else
		    # Duplicate the first and last direction vectors to compensate for not having edges adjacent to the first and last vertices
		    tangents.unshift(tangents.first)
		    tangents.push(tangents.last)
		end
	    end
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
