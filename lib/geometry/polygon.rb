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
		    push_edge Edge.new(previous, n)
		    push_vertex n
		    n
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
