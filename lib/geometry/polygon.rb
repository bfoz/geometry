require_relative 'edge'
require_relative 'polyline'

module Geometry

=begin rdoc
A {Polygon} is a closed path comprised entirely of lines so straight they don't even curve.

{http://en.wikipedia.org/wiki/Polygon}

The {Polygon} class is generally intended to represent {http://en.wikipedia.org/wiki/Simple_polygon Simple polygons},
but there's currently nothing that enforces simplicity.

== Usage

=end

    class Polygon < Polyline

	# Construct a new Polygon from Points and/or Edges
	#  The constructor will try to convert all of its arguments into {Points} and
	#   {Edges}. Then successive {Points} will be collpased into {Edges}. Successive
	#   {Edges} that share a common vertex will be added to the new {Polygon}. If
	#   there's a gap between {Edges} it will be automatically filled with a new
	#   {Edge}. The resulting Polygon will then be closed, if it isn't already.
	# @overload initialize(Edge, Edge, ...)
	#   @return [Polygon]
	# @overload initialize(Point, Point, ...)
	#   @return [Polygon]
	def initialize(*args)
	    super
	    close!	# A Polygon is always closed
	end

	# This method returns the receiver because a {Polygon} is always closed
	# @return [Polygon]	the receiver
	def close
	    close!
	end

	# Check the orientation of the {Polygon}
	# @return [Boolean] True if the {Polygon} is clockwise, otherwise false
	def clockwise?
	    edges.map {|e| (e.last.x - e.first.x) * (e.last.y + e.first.y)}.reduce(:+) >= 0
	end

	# @return [Polygon] A new {Polygon} with orientation that's the opposite of the receiver
	def reverse
	    self.class.new *(self.vertices.reverse)
	end

	# Reverse the receiver and return it
	# @return [Polygon]	the reversed receiver
	def reverse!
	    super

	    # Simply reversing the vertex array causes the reversed polygon to
	    #  start at what had been the last vertex, instead of starting at
	    #  the same vertex and just going the other direction.
	    vertices.unshift vertices.pop

	    self
	end

	# @group Boolean operators

	# Test a {Point} for inclusion in the receiver using a simplified winding number algorithm
	# @param [Point] point	The {Point} to test
	# @return [Number]	1 if the {Point} is inside the {Polygon}, -1 if it's outside, and 0 if it's on an {Edge}
	def <=>(point)
	    sum = edges.reduce(0) do |sum, e|
		direction = e.last.y <=> e.first.y
		# Ignore edges that don't cross the point's x coordinate
		next sum unless ((point.y <=> e.last.y) + (point.y <=> e.first.y)).abs <= 1

		if 0 == direction   # Special case horizontal edges
		    return 0 if ((point.x <=> e.last.x) + (point.x <=> e.first.x)).abs <= 1
		    next sum	    # Doesn't intersect
		else
		    is_left = e <=> point
		    return 0 if 0 == is_left
		    next sum unless is_left
		    sum += 0 <=> (direction + is_left)
		end
	    end
	    (0 == sum) ? -1 : 1
	end

	# Create a new {Polygon} that's the union of the receiver and a passed {Polygon}
	#  This is a simplified implementation of the alogrithm outlined in the
	#  paper {http://gvu.gatech.edu/people/official/jarek/graphics/papers/04PolygonBooleansMargalit.pdf An algorithm for computing the union, intersection or difference of two polygons}.
	#  In particular, this method assumes the receiver and passed {Polygon}s are "island" type and that the desired output is "regular", as those terms are described in the paper.
	# @param [Polygon] other    The {Polygon} to union with the receiver
	# @return [Polygon] The union of the receiver and the passed {Polygon}
	def union(other)
	    # Table 1: Both polygons are islands and the operation is union, so both must have the same orientation
	    # Reverse the other polygon if the orientations are different
	    other = other.reverse if self.clockwise? != other.clockwise?

	    # Receiver's vertex ring
	    ringA = VertexRing.new
	    self.vertices.each {|v| ringA.push v, (other <=> v)}

	    # The other vertex ring
	    ringB = VertexRing.new
	    other.vertices.each {|v| ringB.push v, (self <=> v)}

	    # Find intersections
	    offsetA = 0
	    edgesB = other.edges.dup
	    self.edges.each_with_index do |a, indexA|
		offsetB = 0
		ringB.edges_with_index do |b, indexB|
		    intersection = a.intersection(b)
		    if intersection === true
			if (a.first == b.first) and (a.last == b.last)	    # Equal edges
			elsif (a.first == b.last) and (a.last == b.first)   # Ignore equal but opposite edges
			else
			    if a.direction == b.direction # Same direction?
				offsetA += 1 if ringA.insert_boundary(indexA + 1 + offsetA, b.first)
				offsetB += 1 if ringB.insert_boundary(indexB + 1 + offsetB, a.last)
			    else    # Opposite direction
				offsetA += 1 if ringA.insert_boundary(indexA + 1 + offsetA, b.last)
				offsetB += 1 if ringB.insert_boundary(indexB + 1 + offsetB, a.first)
			    end
			end
		    elsif intersection.is_a?(Point)
			offsetA += 1 if ringA.insert_boundary(indexA + 1 + offsetA, intersection)
			offsetB += 1 if ringB.insert_boundary(indexB + 1 + offsetB, intersection)
		    end
		end
	    end

	    # Table 2: Both polygons are islands and the operation is union, so select outside from both polygons
	    edgeFragments = []
	    [[ringA, other], [ringB, self]].each do |ring, other_polygon|
		ring.edges do |v1,v2|
		    if (v1[:type] == -1) or (v2[:type] == -1)
			edgeFragments.push :first => v1[:vertex], :last => v2[:vertex]
		    elsif (v1[:type] == 0) and (v2[:type] == 0)
			if (other_polygon <=> Point[(v1[:vertex] + v2[:vertex])/2]) <= 0
			    edgeFragments.push :first => v1[:vertex], :last => v2[:vertex]
			end
		    end
		end
	    end

	    # Delete any duplicated edges. Array#uniq doesn't do the right thing, so using inject instead.
	    edgeFragments = edgeFragments.inject([]) {|result,h| result << h unless result.include?(h); result}

	    # Delete any equal-and-opposite edges
	    edgeFragments = edgeFragments.reject {|f| edgeFragments.find {|f2| (f[:first] == f2[:last]) and (f[:last] == f2[:first])} }

	    # Construct the output polygons
	    output = edgeFragments.reduce([Array.new]) do |output, fragment|
		next output if fragment.empty?
		polygon = output.last
		polygon.push fragment[:first], fragment[:last] if polygon.empty?
		while 1 do
		    adjacent_fragment = edgeFragments.find {|f| fragment[:last] == f[:first]}
		    break unless adjacent_fragment

		    polygon.push adjacent_fragment[:first], adjacent_fragment[:last]
		    fragment = adjacent_fragment.dup
		    adjacent_fragment.clear

		    break if polygon.first == polygon.last	# closed?
		end
		output << Array.new
	    end

	    # If everything worked properly there should be only one output Polygon
	    output.reject! {|a| a.empty?}
	    output = Polygon.new *(output[0])

	    # Table 4: Both input polygons are "island" type and the operation
	    #  is union, so the output polygon's orientation should be the same
	    #  as the input polygon's orientation
	    (self.clockwise? != output.clockwise?) ? output.reverse : output
	end
	alias :+ :union

	# @endgroup

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
	    bisector_edges = outset_bisectors(distance)
	    bisector_pairs = bisector_edges.push(bisector_edges.first).each_cons(2)

	    # Create the offset edges and then wrap them in Hashes so the edges
	    #  can be altered while walking the array
	    active_edges = edges.zip(bisector_pairs).map do |e,offset|
		offset_edge = Edge.new(e.first+offset.first.vector, e.last+offset.last.vector)

		# Skip zero-length edges
		{:edge => (offset_edge.first == offset_edge.last) ? nil : offset_edge}
	    end

	    # Walk the array and handle any intersections
	    active_edges.each_with_index do |e, i|
		e1 = e[:edge]
		next unless e1	# Ignore deleted edges

		intersection, j = find_last_intersection(active_edges, i, e1)
		if intersection
		    e2 = active_edges[j][:edge]
		    wrap_around_is_shortest = ((i + active_edges.count - j) < (j-i))

		    if intersection.is_a? Point
			if wrap_around_is_shortest
			    active_edges[i][:edge] = Edge.new(intersection, e1.last)
			    active_edges[j][:edge] = Edge.new(e2.first, intersection)
			else
			    active_edges[i][:edge] = Edge.new(e1.first, intersection)
			    active_edges[j][:edge] = Edge.new(intersection, e2.last)
			end
		    else
			# Handle the collinear case
			active_edges[i][:edge] = Edge.new(e1.first, e2.last)
			active_edges[j].delete(:edge)
			wrap_around_is_shortest = false
		    end

		    # Delete everything between e1 and e2
		    if wrap_around_is_shortest	# Choose the shortest path
			for k in 0...i do
			    active_edges[k].delete(:edge)
			end
			for k in j...active_edges.count do
			    next if k==j    # Exclude e2
			    active_edges[k].delete(:edge)
			end
		    else
			for k in i...j do
			    next if k==i    # Exclude e1 and e2
			    active_edges[k].delete(:edge)
			end
		    end

		    redo    # Recheck the modified edges
		end
	    end
	    Polygon.new *(active_edges.map {|e| e[:edge]}.compact.map {|e| [e.first, e.last]}.flatten)
	end

	# Vertex bisectors suitable for outsetting
	# @param [Number] length    The distance to offset by
	# @return [Array<Edge>]	{Edge}s representing the bisectors
	def outset_bisectors(length)
	    vertices.zip(spokes).map {|v,b| b ? Edge.new(v, v+(b * length)) : nil}
	end

	# Generate the unit-length spokes for each vertex
	# @return [Array<Vector>]   the unit {Vector}s representing the spoke of each vertex
	def spokes
	    clockwise? ? left_bisectors : right_bisectors
	end

	private

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
    end

    private

    class VertexRing
	attr_reader :vertices

	def initialize
	    @vertices = []
	end

	# @param [Integer] index	The index to insert the new {Point} before
	# @param [Point] point		The {Point} to insert
	# @param [Integer] type		The vertex type: 1 is inside, 0 is boundary, -1 is outside
	def insert(index, point, type)
	    if v = @vertices.find {|v| v[:vertex] == point }
		v[:type] = type
		false
	    else
		@vertices.insert(index, {:vertex => point, :type => type})
		true
	    end
	end

	# Insert a boundary vertex
	# @param [Integer] index	The index to insert the new {Point} before
	# @param [Point] point		The {Point} to insert
	def insert_boundary(index, point)
	    self.insert(index, point, 0)
	end

	# @param [Point] point		The {Point} to push
	# @param [Integer] type		The vertex type: 1 is inside, 0 is boundary, -1 is outside
	def push(point, type)
	    @vertices << {:vertex => point, :type => type}
	end

	# Enumerate the pairs of vertices corresponding to each edge
	def edges
	    (@vertices + [@vertices.first]).each_cons(2) {|v1,v2| yield v1, v2}
	end

	def edges_with_index
	    index = 0
	    (@vertices + [@vertices.first]).each_cons(2) {|v1,v2| yield(Edge.new(v1[:vertex], v2[:vertex]), index); index += 1}
	end
    end
end
