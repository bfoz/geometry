require_relative 'point'

module Geometry
    NotSquareError = Class.new(ArgumentError)

=begin
The {Square} class cluster is like the {Rectangle} class cluster, but not longer in one direction.

== Constructors

    Square.new from:[1,2], to:[2,3]	# Using two corners
    Square.new origin:[3,4], size:5	# Using an origin point and a size
    Square.new center:[5,5], size:5	# Using a center point and a size
    Square.new size:5			# Centered on the origin
=end
    class Square
	include ClusterFactory

	# @!attribute origin
	#   @return [Point]  The {Square}'s origin
	attr_reader :origin

	# @!attribute points
	#   @return [Array<Point>]  the corner {Point}s of the {Square} in counter-clockwise order
	attr_reader :points
	alias :vertices :points

	# @overload new(:origin, :size)
	#  Creates a {Square} with the given origin and size
	#  @option [Point]  :origin The lower-left corner
	#  @option [Number] :size   Bigness
	#  @return [CenteredSquare]
	def self.new(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    if options.key?(:size)
		unless options[:size].is_a? Numeric
		    raise NotSquareError, 'Size must be a square' unless options[:size].all? {|a| a == options[:size].first}
		    options[:size] = options[:size].first
		end

		if options.key? :origin
		    SizedSquare.new(options[:origin], options[:size])
		else
		    CenteredSquare.new(options[:center] || PointZero.new, options[:size])
		end
	    elsif options.key?(:from) and options.key?(:to)
		original_new(from: options[:from], to: options[:to])
	    end
	end

	# Creates a {Square} given two {Point}s
	# @option options [Point] :from	A corner (ie. bottom-left)
	# @option options [Point] :to	The other corner (ie. top-right)
	# @option options [Point] :origin   The lower left corner
	def initialize(options={})
	    origin = options[:from] || options[:origin]
	    origin = origin ? Point[origin] : PointZero.new

	    if options.has_key? :to
		point1 = options[:to]
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
	# @!attribute closed?
	#   @return [Bool]  always true
	def closed?
	    true
	end

	# @!attribute [r] edges
	#   @return [Array<Edge>]  An array of {Edge}s corresponding to the sides of the {Square}
	def edges
	    (points + [points.first]).each_cons(2).map {|v1,v2| Edge.new v1, v2}
	end

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

	def points
	    p0, p1 = *@points
	    [p0, Point[p1.x, p0.y], p1, Point[p0.x, p1.y]]
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

	# @!attribute size
	#   @return [Size]  The {Size} of the {Square}
	attr_accessor :size

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
	# @!attribute size
	#   @return [Size]  The {Size} of the {Square}
	attr_accessor :size

	# @param [Point]    origin  The origin point (bottom-left corner)
	# @param [Numeric]  size    The length of each side
	def initialize(origin, size)
	    @origin = Point[origin]
	    @size = size
	end

# @group Accessors
	# @!attribute center
	#   @return [Point]  The center of it all
	def center
	    origin + size/2
	end

	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    origin + size
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    origin
	end

	# @attribute [r] origin
	# @return [Point] The lower left corner
	def origin
	    @origin
	end

	# @attribute [r] points
	# @return [Array<Point>]    The {Square}'s four points (counterclockwise)
	def points
	    minx = origin.x
	    maxx = origin.x + size
	    miny = origin.y
	    maxy = origin.y + size

	    [origin, Point[maxx, miny], Point[maxx, maxy], Point[minx,maxy]]
	end

	# @return [Number]  The size of the {Square} along the y-axis
	def height
	    @size
	end

	# @return [Number]  The size of the {Square} along the x-axis
	def width
	    @size
	end
# @endgroup
    end
end
