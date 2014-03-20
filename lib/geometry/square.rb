require_relative 'point'

module Geometry
    NotSquareError = Class.new(ArgumentError)

=begin
The {Square} class cluster is like the {Rectangle} class cluster, but not longer in one direction.

== Constructors

    square = Square.new from:[1,2], to:[2,3]	# Using two corners
    square = Square.new origin:[3,4], size:5	# Using an origin point and a size
=end
    class Square
	attr_reader :origin

	# Creates a {Square} given two {Point}s
	# @option options [Point] :from	A corner (ie. bottom-left)
	# @option options [Point] :to	The other corner (ie. top-right)
	# @option options [Point] :origin   The lower left corner
	# @option options [Number] :size    Bigness
	def initialize(options={})
	    origin = options[:from] || options[:origin]
	    origin = origin ? Point[origin] : PointZero.new

	    if options.has_key? :to
		point1 = options[:to]
	    elsif options.has_key? :size
		point1 = origin + options[:size]
	    end

	    point1 = Point[point1]
	    raise(ArgumentError, "Point sizes must match (#{origin.size} != #{point1.size})") unless origin.is_a?(PointZero) || (origin.size == point1.size)

	    # Reorder the points to get lower-left and upper-right
	    minx, maxx = [origin.x, point1.x].minmax
	    miny, maxy = [origin.y, point1.y].minmax
	    @points = [Point[minx, miny], Point[maxx, maxy]]

	    raise(NotSquareError) if height != width
	end

# !@group Accessors
	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @points.last
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @points.first
	end

	# @return [Array<Point>]    The lower left and upper right corners of the bounding {Rectangle}
	def minmax
	    [self.min, self.max]
	end

	# @attribute [r] origin
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
# @endgroup
    end

    # A {Square} created with a center point and a size
    class CenteredSquare < Square
	# @attribute [r] center
	# @return [Point]   The center of the {Square}
	attr_reader :center

	# @param [Point]	center	The center point
	# @param [Numeric]	size	The length of each side
	def initialize(center, size)
	    @center = Point[center]
	    @size = size
	end

# @group Accessors
	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    half_size = @size/2
	    Point[@center.x + half_size, @center.y + half_size]
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    half_size = @size/2
	    Point[@center.x - half_size, @center.y - half_size]
	end

	# @return [Array<Point>]    The lower left and upper right corners of the bounding {Rectangle}
	def minmax
	    [self.min, self.max]
	end

	# @attribute [r] origin
	# @return [Point] The lower left corner
	def origin
	    Point[@center.x - size/2, @center.y - size/2]
	end

	# @attribute [r] points
	# @return [Array<Point>]    The {Square}'s four points (counterclockwise)
	def points
	    half_size = @size/2
	    minx = @center.x - half_size
	    maxx = @center.x + half_size
	    miny = @center.y - half_size
	    maxy = @center.y + half_size

	    [Point[minx,miny], Point[maxx, miny], Point[maxx, maxy], Point[minx,maxy]]
	end

	def height
	    @size
	end

	def width
	    @size
	end
# @endgroup
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
