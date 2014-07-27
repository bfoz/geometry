require 'matrix'

require_relative 'size_one'
require_relative 'size_zero'

module Geometry
=begin
An object representing the size of something.
 
Supports all of the familiar {Vector} methods as well as a few convenience 
methods (width, height and depth).
 
== Usage
 
=== Constructor
   size = Geometry::Size[x,y,z]
=end

    class Size < Vector
	attr_reader :x, :y, :z
	
	# Allow vector-style initialization, but override to support copy-init
	# from Vector, Point or another Size
	#
	# @overload [](x,y,z,...)
	# @overload [](Point)
	# @overload [](Size)
	# @overload [](Vector)
	# @return [Size]    A new {Size} object
	def self.[](*array)
	    array.map! {|a| a.respond_to?(:to_a) ? a.to_a : a }
	    array.flatten!
	    super *array
	end

	# Creates and returns a new {SizeOne} instance. Or, a {Size} full of ones if the size argument is given.
	# @param size [Number] the size of the new {Size} full of ones
	# @return [SizeOne] A new {SizeOne} instance
	def self.one(size=nil)
	    size ? Size[Array.new(size, 1)] : SizeOne.new
	end

	# Creates and returns a new {SizeOne} instance. Or, a {Size} full of zeros if the size argument is given.
	# @param size [Number] the size of the new {Size} full of zeros
	# @return [SizeOne] A new {SizeOne} instance
	def self.zero(size=nil)
	    size ? Size[Array.new(size, 0)] : SizeOne.new
	end

	# Allow comparison with an Array, otherwise do the normal thing
	def ==(other)
	    return @elements == other if other.is_a?(Array)
	    super other
	end

	# Override Vector#[] to allow for regular array slicing
	def [](*args)
	    @elements[*args]
	end

	def coerce(other)
	    case other
		when Array then [Size[*other], self]
		when Numeric then [Size[Array.new(self.size, other)], self]
		when Vector then [Size[*other], self]
		else
		raise TypeError, "#{self.class} can't be coerced into #{other.class}"
	    end
	end

	def inspect
	    'Size' + @elements.inspect
	end
	def to_s
	    'Size' + @elements.to_s
	end

	# @return [Number]  The size along the Z axis
	def depth
	    z
	end

	# @return [Number]  The size along the Y axis
	def height
	    y
	end

	# @return [Number]  The size along the X axis
	def width
	    x
	end

	# @return [Number] X-component (width)
	def x
	    @elements[0]
	end

	# @return [Number] Y-component (height)
	def y
	    @elements[1]
	end

	# @return [Number] Z-component (depth)
	def z
	    @elements[2]
	end

	# Create a new {Size} that is smaller than the receiver by the specified amounts
	# @overload inset(x,y)
	# @param x [Number] the horizontal inset
	# @param y [Number] the vertical inset
	# @overload inset(options)
	# @option options [Number] :left    the left inset
	# @option options [Number] :right   the right inset
	# @option options [Number] :top	    the top inset
	# @option options [Number] :bottom  the bottom inset
	def inset(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    left = right = top = bottom = 0
	    if 1 == args.size
		left = top = -args.shift
		right = bottom = 0
	    elsif 2 == args.size
		left = right = -args.shift
		top = bottom = -args.shift
	    end

	    left = right = -options[:x] if options[:x]
	    top = bottom = -options[:y] if options[:y]

	    top = -options[:top] if options[:top]
	    left = -options[:left] if options[:left]
	    bottom = -options[:bottom] if options[:bottom]
	    right = -options[:right] if options[:right]

	    self.class[left + width + right, top + height + bottom]
	end

	# Create a new {Size} that is larger than the receiver by the specified amounts
	# @overload outset(x,y)
	# @param x [Number] the horizontal inset
	# @param y [Number] the vertical inset
	# @overload outset(options)
	# @option options [Number] :left    the left inset
	# @option options [Number] :right   the right inset
	# @option options [Number] :top	    the top inset
	# @option options [Number] :bottom  the bottom inset
	def outset(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    left = right = top = bottom = 0
	    if 1 == args.size
		left = top = args.shift
		right = bottom = 0
	    elsif 2 == args.size
		left = right = args.shift
		top = bottom = args.shift
	    end

	    left = right = options[:x] if options[:x]
	    top = bottom = options[:y] if options[:y]

	    top = options[:top] if options[:top]
	    left = options[:left] if options[:left]
	    bottom = options[:bottom] if options[:bottom]
	    right = options[:right] if options[:right]

	    self.class[left + width + right, top + height + bottom]
	end
    end
end
