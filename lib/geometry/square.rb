require_relative 'point'

module Geometry
    NotSquareError = Class.new(ArgumentError)

=begin
The {Square} class cluster is like the {Rectangle} class cluster, but not longer in one direction.

== Constructors

    square = Square.new [1,2], [2,3]	# Using two corners
    square = Square.new [3,4], 5	# Using an origin point and a size
    square = Square.new 6		# Using a size and an origin of [0,0]
=end
    class Square
	attr_reader :origin

	# Creates a {Square} given two {Point}s
	# @param [Point] point0	A corner (ie. bottom-left)
	# @param [Point] point1	The other corner (ie. top-right)
	def initialize(point0, point1)
	    point0, point1 = Point[point0], Point[point1]
	    raise(ArgumentError, "Point sizes must match (#{point0.size} != #{point1.size}") unless point0.size == point1.size

	    # Reorder the points to get lower-left and upper-right
	    minx, maxx = [point0.x, point1.x].minmax
	    miny, maxy = [point0.y, point1.y].minmax
	    @points = [Point[minx, miny], Point[maxx, maxy]]

	    raise(NotSquareError) if height != width
	end

# !@group Accessors
	# !@attribute [r] origin
	# @return [Point] The lower left corner
	def origin
	    @points.first
	end

	def height
	    min, max = @points.minmax {|a,b| a.y <=> b.y}
	    max.y - min.y
	end

	def width
	    min, max = @points.minmax {|a,b| a.x <=> b.x}
	    max.x - min.x
	end
# !@endgroup
    end

    # A {Square} created with a center point and a size
    class CenteredSquare < Square
	# !@attribute [r] center
	# @return [Point]   The center of the {Square}
	attr_reader :center

	# @param [Point]	center	The center point
	# @param [Numeric]	size	The length of each side
	def initialize(center, size)
	    @center = Point[center]
	    @size = size
	end

# !@group Accessors
	# !@attribute [r] origin
	# @return [Point] The lower left corner
	def origin
	    Point[@center.x - size/2, @center.y - size/2]
	end

	# !@attribute [r] points
	# @return [Array<Point>]    The {Square}'s four points (clockwise)
	def points
	    half_size = @size/2
	    minx = @center.x - half_size
	    maxx = @center.x + half_size
	    miny = @center.y - half_size
	    maxy = @center.y + half_size

	    [Point[minx,miny], Point[minx,maxy], Point[maxx, maxy], Point[maxx, miny]]
	end

	def height
	    @size
	end

	def width
	    @size
	end
# !@endgroup
    end

    # A {Square} created with an origin point and a size
    class SizedSquare < Square
	# @param [Point]    origin  The origin point (bottom-left corner)
	# @param [Numeric]  size    The length of each side
	def initialize(origin, size)
	    @origin = Point[origin]
	    @size = size
	end
    end
end
