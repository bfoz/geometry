require_relative 'cluster_factory'
require_relative 'edge'
require_relative 'point'
require_relative 'point_zero'
require_relative 'size'

module Geometry
=begin
The {Rectangle} class cluster represents your typical arrangement of 4 corners and 4 sides.

== Usage

=== Constructors
    rect = Rectangle.new [1,2], [2,3]		    # Using two corners
    rect = Rectangle.new from:[1,2], to:[2,3]	    # Using two corners

    rect = Rectangle.new center:[1,2], size:[1,1]   # Using a center point and a size
    rect = Rectangle.new origin:[1,2], size:[1,1]   # Using an origin point and a size

    rect = Rectangle.new size: [10, 20]         # origin = [0,0], size = [10, 20]
    rect = Rectangle.new size: Size[10, 20]	# origin = [0,0], size = [10, 20]
    rect = Rectangle.new width: 10, height: 20	# origin = [0,0], size = [10, 20]
=end

    class Rectangle
	include ClusterFactory

	# @return [Point]   The {Rectangle}'s center
	attr_reader :center
	# @return [Number]  Height of the {Rectangle}
	attr_reader :height
	# @return [Point]   The {Rectangle}'s origin
	attr_reader :origin
	# @return [Size]    The {Size} of the {Rectangle}
	attr_reader :size
	# @return [Number]  Width of the {Rectangle}
	attr_reader :width

	# @overload new(width, height)
	#   Creates a {Rectangle} of the given width and height, centered on the origin
	#   @param [Number]   height  Height
	#   @param [Number]   width   Width
	#   @return [CenteredRectangle]
	# @overload new(size)
	#   Creates a {Rectangle} of the given {Size} centered on the origin
	#   @param [Size]	size	Width and height
	#   @return [CenteredRectangle]
	# @overload new(point0, point1)
	#   Creates a {Rectangle} using the given {Point}s
	#   @param [Point]    point0	A corner
	#   @param [Point]    point1	The other corner
	# @overload new(origin, size)
	#   Creates a {Rectangle} from the given origin and size
	#   @param [Point]	origin	Lower-left corner
	#   @param [Size]	size	Width and height
	#   @return [SizedRectangle]
	# @overload new(left, bottom, right, top)
	#   Creates a {Rectangle} from the locations of each side
	#   @param [Number]	left	X-coordinate of the left side
	#   @param [Number]	bottom	Y-coordinate of the bottom edge
	#   @param [Number]	right	X-coordinate of the right side
	#   @param [Number]	top	Y-coordinate of the top edge
	def self.new(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    if options.has_key?(:size)
		if options.has_key?(:center)
		    CenteredRectangle.new(center: options[:center], size: options[:size])
		elsif options.has_key?(:origin)
		    SizedRectangle.new(origin: options[:origin], size: options[:size])
		else
		    SizedRectangle.new(size: options[:size])
		end
	    elsif options.has_key?(:from) and options.has_key?(:to)
		original_new(options[:from], options[:to])
	    elsif options.has_key?(:height) and options.has_key?(:width)
		SizedRectangle.new(height: options[:height], width: options[:width])
	    elsif (2==args.count) and (args.all? {|a| a.is_a?(Array) || a.is_a?(Point) })
		original_new(*args)
	    elsif options.empty?
		raise ArgumentError, "#{self} arguments must be named, not: #{args}"
	    else
		raise ArgumentError, "Bad Rectangle arguments: #{args}, #{options}"
	    end
	end

	# Creates a {Rectangle} using the given {Point}s
	#   @param [Point]	point0	A corner (ie. bottom-left)
	#   @param [Point]	point1	The other corner (ie. top-right)
	def initialize(point0, point1)
	    point0 = Point[point0]
	    point1 = Point[point1]
	    raise(ArgumentError, "Point sizes must match") unless point0.size == point1.size

	    # Reorder the points to get lower-left and upper-right
	    if (point0.x > point1.x) && (point0.y > point1.y)
		point0, point1 = point1, point0
	    else
		p0x, p1x = [point0.x, point1.x].minmax
		p0y, p1y = [point0.y, point1.y].minmax
		point0 = Point[p0x, p0y]
		point1 = Point[p1x, p1y]
	    end
	    @points = [point0, point1]
	end

	def eql?(other)
	    self.points == other.points
	end
	alias :== :eql?

# @group Accessors

	# @return [Rectangle]	The smallest axis-aligned {Rectangle} that bounds the receiver
	def bounds
	    return Rectangle.new(self.min, self.max)
	end

	# @return [Point]   The {Rectangle}'s center
	def center
	    min, max = @points.minmax {|a,b| a.y <=> b.y}
	    Point[(max.x+min.x)/2, (max.y+min.y)/2]
	end

	# @!attribute closed?
	#   @return [Bool]  always true
	def closed?
	    true
	end

	# @return [Array<Edge>]   The {Rectangle}'s four edges (counterclockwise)
	def edges
	    point0, point2 = *@points
	    point1 = Point[point2.x, point0.y]
	    point3 = Point[point0.x, point2.y]
	    [Edge.new(point0, point1),
	     Edge.new(point1, point2),
	     Edge.new(point2, point3),
	     Edge.new(point3, point0)]
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

	# @return [Array<Point>]    The {Rectangle}'s four points (counterclockwise)
	def points
	    point0, point2 = *@points
	    point1 = Point[point2.x, point0.y]
	    point3 = Point[point0.x, point2.y]
	    [point0, point1, point2, point3]
	end

	def origin
	    minx = @points.min {|a,b| a.x <=> b.x}
	    miny = @points.min {|a,b| a.y <=> b.y}
	    Point[minx.x, miny.y]
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

	# Create a new {Rectangle} from the receiver that's inset by the given amount
	# @overload inset(x, y)
	# @overload inset(top, left, bottom, right)
	# @overload inset(x, y)
	#   @option options [Number] :x	    Inset from the left and right sides
	#   @option options [Number] :y	    Inset from the top and bottom
	# @overload inset(top, left, bottom, right)
	#   @option options [Number] :bottom	The inset from the bottom of the {Rectangle}
	#   @option options [Number] :left	The inset from the left side of the {Rectangle}
	#   @option options [Number] :right	The inset from the right side of the {Rectangle}
	#   @option options [Number] :top	The inset from the top of the {Rectangle}
	def inset(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)
	    raise ArumentError, "Can't specify both arguments and options" if !args.empty? && !options.empty?

	    if 1 == args.size
		distance = args.shift
		Rectangle.new from:(min + distance), to:(max - distance)
	    elsif 2 == args.size
		distance = Point[*args]
		Rectangle.new from:(min + distance), to:(max - distance)
	    elsif 4 == args.size
		top, left, bottom, right = *args
		Rectangle.new from:(min + Point[left, bottom]), to:(max - Point[right, top])
	    elsif options[:x] && options[:y]
		distance = Point[options[:x], options[:y]]
		Rectangle.new from:(min + distance), to:(max - distance)
	    elsif options[:top] && options[:left] && options[:bottom] && options[:right]
		Rectangle.new from:(min + Point[options[:left], options[:bottom]]), to:(max - Point[options[:right], options[:top]])
	    end
	end
    end

    class CenteredRectangle < Rectangle
	# @return [Point]	The {Rectangle}'s center
	attr_accessor :center
	# @return [Size]	The {Size} of the {Rectangle}
	attr_accessor :size

	# @overload new(width, height)
	#   Creates a {Rectangle} of the given width and height, centered on the origin
	#   @param [Number]   height  Height
	#   @param [Number]   width   Width
	#   @return [CenteredRectangle]
	# @overload new(size)
	#   Creates a {Rectangle} of the given {Size} centered on the origin
	#   @param [Size]	size	Width and height
	#   @return [CenteredRectangle]
	# @overload new(center, size)
	#   Creates a {Rectangle} with the given center point and size
	#   @param [Point]	center
	#   @param [Size]	size
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    @center = options[:center] ? Point[options[:center]] : PointZero.new

	    if options.has_key?(:size)
		@size = Geometry::Size[options[:size]]
	    elsif options.has_key?(:height) and options.has_key?(:width)
		@size = Geometry::Size[options[:width], options[:height]]
	    else
		raise ArgumentError, "Bad arguments to CenteredRectangle#new"
	    end
	end

	def eql?(other)
	    (self.center == other.center) && (self.size == other.size)
	end
	alias :== :eql?

# @group Accessors
	# @return [Array<Edge>]   The {Rectangle}'s four edges
	def edges
	    point0 = @center - @size/2.0
	    point2 = @center + @size/2.0
	    point1 = Point[point0.x,point2.y]
	    point3 = Point[point2.x, point0.y]
	    [Edge.new(point0, point1),
	    Edge.new(point1, point2),
	    Edge.new(point2, point3),
	    Edge.new(point3, point0)]
	end

	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @center + @size/2.0
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @center - @size/2.0
	end

	# @return [Array<Point>]    The {Rectangle}'s four points (clockwise)
	def points
	    point0 = @center - @size/2.0
	    point2 = @center + @size/2.0
	    point1 = Point[point0.x,point2.y]
	    point3 = Point[point2.x, point0.y]
	    [point0, point1, point2, point3]
	end

	def height
	    @size.height
	end

	def width
	    @size.width
	end
# @endgroup
    end

    class SizedRectangle < Rectangle
	# @return [Point]	The {Rectangle}'s origin
	attr_accessor :origin
	# @return [Size]	The {Size} of the {Rectangle}
	attr_accessor :size

	# @overload new(width, height)
	#   Creates a {Rectangle} of the given width and height with its origin at [0,0]
	#   @param [Number]   height  Height
	#   @param [Number]   width   Width
	#   @return SizedRectangle
	# @overload new(size)
	#   Creates a {Rectangle} of the given {Size} with its origin at [0,0]
	#   @param [Size]	size	Width and height
	#   @return SizedRectangle
	# @overload new(origin, size)
	#   Creates a {Rectangle} with the given origin point and size
	#   @param [Point]	origin
	#   @param [Size]	size
	#   @return SizedRectangle
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    @origin = options[:origin] ? Point[options[:origin]] : PointZero.new

	    if options.has_key?(:size)
		@size = Geometry::Size[options[:size]]
	    elsif options.has_key?(:height) and options.has_key?(:width)
		@size = Geometry::Size[options[:width], options[:height]]
	    else
		raise ArgumentError, "Bad arguments to SizeRectangle#new"
	    end
	end

	def eql?(other)
	    (self.origin == other.origin) && (self.size == other.size)
	end
	alias :== :eql?

# @group Accessors
	# @return [Point]   The {Rectangle}'s center
	def center
	    @origin + @size/2
	end

	# @return [Array<Edge>]   The {Rectangle}'s four edges
	def edges
	    point0 = @origin
	    point2 = @origin + @size
	    point1 = Point[point0.x,point2.y]
	    point3 = Point[point2.x, point0.y]
	    [Edge.new(point0, point1),
	    Edge.new(point1, point2),
	    Edge.new(point2, point3),
	    Edge.new(point3, point0)]
	end

	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @origin + @size
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @origin
	end

	# @return [Array<Point>]    The {Rectangle}'s four points (clockwise)
	def points
	    point0 = @origin
	    point2 = @origin + @size
	    point1 = Point[point0.x,point2.y]
	    point3 = Point[point2.x, point0.y]
	    [point0, point1, point2, point3]
	end

	def height
	    @size.height
	end

	def width
	    @size.width
	end
# @endgroup
    end
end
