require_relative 'edge'

module Geometry

=begin rdoc
An object representing a closed set of vertices and edges.

{http://en.wikipedia.org/wiki/Polygon}

== Usage

=end

    class Polygon
	attr_reader :edges, :vertices
	alias :points :vertices

	# Construct a new Polygon from Points and/or Edges
	#  The constructor will try to convert all of its arguments into Points and
	#   Edges. Then successive Points will be collpased into Edges. Successive
	#   Edges that share a common vertex will be added to the new Polygon. If
	#   there's a gap between Edges it will be automatically filled with a new
	#   Edge. The resulting Polygon will then be closed if it isn't already.
	# @overload initialize(Array, Array, ...)
	#   @return [Polygon]
	# @overload initialize(Edge, Edge, ...)
	#   @return [Polygon]
	# @overload initialize(Point, Point, ...)
	#   @return [Polygon]
	# @overload initialize(Vector, Vector, ...)
	#   @return [Polygon]
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
				@edges.pop				# Remove the previous Edge
				@vertices.pop(@edges.size ? 1 : 2)	# Remove the now unused vertex, or vertices
				if n == @edges.last.last
				    @edges.last.last
				else
				    push_edge Edge.new(@edges.last.last, n)
				    push_vertex @edges.last.first
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

	    # Close the polygon if needed
	    @edges.push Edge.new(@edges.last.last, @edges.first.first) unless @edges.empty? || (@edges.last.last == @edges.first.first)
	end

	# Check the equality of two {Polygon}s. Note that if two {Polygon}s have
	#  opposite winding, but are otherwise identical, they will be considered unequal.
	# @return [Bool] true if both {Polygon}s have equal edges
	def eql?(other)
	    @vertices.zip(other.vertices).all? {|a,b| a == b}
	end
	alias :== :eql?

	# @group Convex Hull


	# Returns the convex hull of the {Polygon}
	# @return [Polygon] A convex {Polygon}, or the original {Polygon} if it's already convex
	def convex
	    wrap
	end

	# Returns the convex hull using the {http://en.wikipedia.org/wiki/Gift_wrapping_algorithm Gift Wrapping algorithm}
	#  This implementation was cobbled together from many sources, but mostly from this implementation of the {http://butunclebob.com/ArticleS.UncleBob.ConvexHullTiming Jarvis March}
	# @return [Polygon]
	def wrap
	    # Start with a Point that's guaranteed to be on the hull
	    leftmost_point = vertices.min_by {|v| v.x}
	    current_point = vertices.select {|v| v.x == leftmost_point.x}.min_by {|v| v.y}

	    current_angle = 0.0
	    hull_points = [current_point]
	    while true
		min_angle = 4.0
		min_point = nil
		vertices.each do |v1|
		    next if current_point.equal? v1
		    angle = pseudo_angle_for_edge(current_point, v1)
		    min_point, min_angle = v1, angle if (angle >= current_angle) && (angle <= min_angle)
		end
		current_angle = min_angle
		current_point = min_point
		break if current_point == hull_points.first
		hull_points << min_point
	    end
	    Polygon.new *hull_points
	end

	# @endgroup

	# Outset the receiver by the specified distance
	# @param [Number] distance	The distance to offset by
	# @return [Polygon] A new {Polygon} outset by the given distance
	def outset(distance)
	    bisectors = offset_bisectors(distance)
	    offsets = (bisectors.each_cons(2).to_a << [bisectors.last, bisectors.first])

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
	    Polygon.new *(active_edges.map {|e| e[:edge]}.compact.map {|e| [e.first, e.last]}.flatten)
	end

	# Vertex bisectors suitable for offsetting
	# @param [Number] length    The distance to offset by
	# @return [Array<Edge>]	{Edge}s representing the bisectors
	def offset_bisectors(length)
	    vectors = edges.map {|e| e.direction }
	    winding = 0
	    sums = vectors.unshift(vectors.last).each_cons(2).map do |v1,v2|
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

	    # Check the polygon's orientation. If clockwise, negate length as a hack for injecting a -1 into the final result
	    length = -length if winding >= 0
	    vertices.zip(sums).map {|v,b| b ? Edge.new(v, v+(b * length)) : nil}
	end

	private

	# @group Helpers for outset()

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

	# Return a number that increases with the slope of the {Edge}
	# @return [Number]  A number in the range [0,4)
	def pseudo_angle_for_edge(point0, point1)
	    delta = Point[point1.x.to_f, point1.y.to_f] - Point[point0.x.to_f, point0.y.to_f]
	    if delta.x >= 0
		if delta.y >= 0
		    quadrant_one_psuedo_angle(delta.x, delta.y)
		else
		    1 + quadrant_one_psuedo_angle(delta.y.abs, delta.x)
		end
	    else
		if delta.y >= 0
		    3 + quadrant_one_psuedo_angle(delta.y, delta.x.abs)
		else
		    2 + quadrant_one_psuedo_angle(delta.x.abs, delta.y.abs)
		end
	    end
	end

	def quadrant_one_psuedo_angle(dx, dy)
	    dx / (dx + dy)
	end

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
