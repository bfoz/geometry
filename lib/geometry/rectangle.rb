require_relative 'cluster_factory'
require_relative 'edge'
require_relative 'point'
require_relative 'size'

module Geometry
=begin
The {Rectangle} class cluster represents your typical arrangement of 4 corners and 4 sides.

== Usage

=== Constructors
    rect = Rectangle[[1,2], [2,3]]      # Using two corners
    rect = Rectangle[[1,2], Size[1,1]]  # Using origin and size
    rect = Rectangle[1,2,2,3]           # Using four sides

    rect = Rectangle[10, 20]            # origin = [0,0], size = [10, 20]
    rect = Rectangle[Size[10, 20]]      # origin = [0,0], size = [10, 20]

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
	    case args.size
		when 1
		    CenteredRectangle.new(args[0])
		when 2
		    if args.all? {|a| a.is_a?(Numeric) }
			CenteredRectangle.new(Size[*args])
		    elsif args.all? {|a| a.is_a?(Array) || a.is_a?(Point) }
			original_new(*args)
		    elsif (args[0].is_a?(Point) or args[0].is_a?(Array))and args[1].is_a?(Size)
			SizedRectangle.new(*args)
		    else
			raise ArgumentError, "Invalid arguments #{args}"
		    end
		when 4
		    raise ArgumentError unless args.all? {|a| a.is_a?(Numeric)}
		    left, bottom, right, top = *args
		    original_new(Point[left, bottom], Point[right, top])
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

	# @return [Point]   The {Rectangle}'s center
	def center
	    min, max = @points.minmax {|a,b| a.y <=> b.y}
	    Point[(max.x+min.x)/2, (max.y+min.y)/2]
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
    end

    class CenteredRectangle < Rectangle
	# @return [Point]	The {Rectangle}'s center
	attr_accessor :center
	attr_reader :origin
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
	    if args[0].is_a?(Size)
		@center = Point[0,0]
		@size = args[0]
	    elsif args[0].is_a?(Geometry::Point) and args[1].is_a?(Geometry::Size)
		@center, @size = args[0,1]
	    elsif (2 == args.size) and args.all? {|a| a.is_a?(Numeric)}
		@center = Point[0,0]
		@size = Geometry::Size[*args]
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
	# @return [Point]   The {Rectangle}'s center
	attr_reader :center
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
	    if args[0].is_a?(Size)
		@origin = Point[0,0]
		@size = args[0]
	    elsif (args[0].is_a?(Point) or args[0].is_a?(Array)) and args[1].is_a?(Geometry::Size)
		@origin, @size = Point[args[0]], args[1]
	    elsif (2 == args.size) and args.all? {|a| a.is_a?(Numeric)}
		@origin = Point[0,0]
		@size = Geometry::Size[*args]
	    end
	end

	def eql?(other)
	    (self.origin == other.origin) && (self.size == other.size)
	end
	alias :== :eql?

# @group Accessors
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
