require_relative 'cluster_factory'
require_relative 'point'

module Geometry
=begin rdoc
A {http://en.wikipedia.org/wiki/Triangle Triangle} is not a square.

== Usage
A right {Triangle} with its right angle at the origin and sides of length 1
    triangle = Geometry::Triangle.new [0,0], [1,0], [0,1]

An isoscoles right {Triangle} created with an origin and leg length
    triangle = Geometry::Triangle.new [0,0], 1
=end

    # @abstract Factory class that instantiates the appropriate subclasses
    class Triangle

	include ClusterFactory

	# @overload new(point0, point1, point2)
	#   Contruct a {ScaleneTriangle} using three {Point}s
	#   @param [Point] point0   The first vertex of the {Triangle}
	#   @param [Point] point1   Another vertex of the {Triangle}
	#   @param [Point] point2   The final vertex of the {Triangle}
	# @overload new(point, length)
	#   Construct a {RightTriangle} using a {Point} and the lengths of the sides
	#   @param [Point] point    The location of the vertex at {Triangle}'s right angle
	#   @param [Number] base    The length of the {Triangle}'s base leg
	#   @param [Number] height  The length of the {Triangle}'s vertical leg
	def self.new(*args)
	     if args.size == 3
		ScaleneTriangle.new *args
	     elsif args.size == 2
		RightTriangle.new args[0], args[1], args[1]
	     end
	end

	# @!attribute closed?
	#   @return [Bool]  always true
	def closed?
	    true
	end

	# @return [Point]   The upper-right corner of the bounding rectangle that encloses the {Polyline}
	def max
	    points.reduce {|memo, vertex| Point[[memo.x, vertex.x].max, [memo.y, vertex.y].max] }
	end

	# @return [Point]   The lower-left corner of the bounding rectangle that encloses the {Polyline}
	def min
	    points.reduce {|memo, vertex| Point[[memo.x, vertex.x].min, [memo.y, vertex.y].min] }
	end

	# @return [Array<Point>]    The lower-left and upper-right corners of the enclosing bounding rectangle
	def minmax
	    points.reduce([points.first, points.first]) {|memo, vertex| [Point[[memo.first.x, vertex.x].min, [memo.first.y, vertex.y].min], Point[[memo.last.x, vertex.x].max, [memo.last.y, vertex.y].max]] }
	end
    end

    # {http://en.wikipedia.org/wiki/Equilateral_triangle Equilateral Triangle}
    class EquilateralTriangle < Triangle
	def self.new(*args)
	    original_new(*args)
	end
    end

    class IsoscelesTriangle < Triangle
	def self.new(*args)
	    original_new(*args)
	end
    end

    # {http://en.wikipedia.org/wiki/Right_triangle Right Triangle}
    class RightTriangle < Triangle
	attr_reader :origin, :base, :height

	# Construct a Right Triangle given a {Point} and the leg lengths
	def initialize(origin, base, height)
	    @origin = Point[origin]
	    @base, @height = base, height
	end

	# An array of points corresponding to the vertices of the {Triangle} (clockwise)
	# @return [Array<Point>]    Vertices
	def points
	    [@origin, @origin + Point[0,@height], @origin + Point[@base,0]]
	end
    end

    class ScaleneTriangle < Triangle
	attr_reader :points

	# Construct a scalene {Triangle}
	def initialize(point0, point1, point2)
	    @points = [point0, point1, point2].map {|p| Point[p] }
	end
    end
end
