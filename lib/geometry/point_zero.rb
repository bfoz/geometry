require_relative 'point'
require_relative 'point_iso'

module Geometry
=begin rdoc
An object repesenting a {Point} at the origin in N-dimensional space

A {PointZero} object is a {Point} that will always compare equal to zero and unequal to
everything else, regardless of size. You can think of it as an application of the
{http://en.wikipedia.org/wiki/Null_Object_pattern Null Object Pattern}.
=end
    class PointZero
	def eql?(other)
	    if other.respond_to? :all?
		other.all? {|e| e.eql? 0}
	    else
		other == 0
	    end
	end
	alias == eql?

	def coerce(other)
	    if other.is_a? Numeric
		[other, 0]
	    elsif other.is_a? Array
		[other, Array.new(other.size,0)]
	    elsif other.is_a? Vector
		[other, Vector[*Array.new(other.size,0)]]
	    else
		[Point[other], Point[Array.new(other.size,0)]]
	    end
	end

	def is_a?(klass)
	    (klass == Point) || super
	end
	alias :kind_of? :is_a?

	# This is a hack to get Array#== to work properly. It works on ruby 2.0 and 1.9.3.
	def to_ary
	    []
	end

# @group Accessors
	# @param [Integer]  i	Index into the {Point}'s elements
	# @return [Numeric] Element i (starting at 0)
	def [](i)
	    0
	end

	# @attribute [r] x
	#   @return [Numeric] X-component
	def x
	    0
	end

	# @attribute [r] y
	#   @return [Numeric] Y-component
	def y
	    0
	end

	# @attribute [r] z
	#   @return [Numeric] Z-component
	def z
	    0
	end
# @endgroup

	# @override max()
	# @return [Number]  The maximum value of the {Point}'s elements
	# @override max(point)
	# @return [Point]    The element-wise maximum values of the receiver and the given {Point}
	def max(*args)
	    if args.empty?
		0
	    else
		args = args.first if 1 == args.size
		Array.new(args.size, 0).zip(args).map(&:max)
	    end
	end

	# @override min()
	# @return [Number]  The minimum value of the {Point}'s elements
	# @override min(point)
	# @return [Point]    The element-wise minimum values of the receiver and the given {Point}
	def min(*args)
	    if args.empty?
		0
	    else
		args = args.first if 1 == args.size
		Array.new(args.size, 0).zip(args).map(&:min)
	    end
	end

	# @override minmax()
	# @return [Array<Number>]   The minimum value of the {Point}'s elements
	# @override min(point)
	# @return [Array<Point>]    The element-wise minimum values of the receiver and the given {Point}
	def minmax(*args)
	    if args.empty?
		[0, 0]
	    else
		[min(*args), max(*args)]
	    end
	end

	# Returns a new {Point} with the given number of elements removed from the end
	# @return [Point]   the popped elements
	def pop(count=1)
	    Point[Array.new(count, 0)]
	end

	# Removes the first element and returns it
	# @return [Point]   the shifted elements
	def shift(count=1)
	    Point[Array.new(count, 0)]
	end

# @group Arithmetic

# @group Unary operators
	def +@
	    self
	end

	def -@
	    self
	end
# @endgroup

	def +(other)
	    case other
		when Array then other
		when Numeric
		    Point.iso(other)
		else
		    Point[other]
	    end
	end

	def -(other)
	    if other.is_a? Size
		-Point[other]
	    elsif other.is_a? Numeric
		Point.iso(-other)
	    elsif other.respond_to? :-@
		-other
	    elsif other.respond_to? :map
		other.map {|a| -a }
	    end
	end

	def *(other)
	    self
	end

	def /(other)
	    raise OperationNotDefined unless other.is_a? Numeric
	    raise ZeroDivisionError if 0 == other
	    self
	end
# @endgroup

	# @group Enumerable

	# Return the first, or first n, elements (always 0)
	# @param n [Number]	the number of elements to return
	def first(n=nil)
	    Array.new(n, 0) rescue 0
	end
	# @endgroup
    end
end

