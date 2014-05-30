require_relative 'point'

module Geometry
=begin rdoc
An object repesenting a {Point} that is one unit away from the origin, along each
axis, in N-dimensional space

A {PointOne} object is a {Point} that will always compare equal to one and unequal to
everything else, regardless of size. It's similar to the
{http://en.wikipedia.org/wiki/Null_Object_pattern Null Object Pattern}, but for ones.
=end
    class PointOne
	def eql?(other)
	    if other.respond_to? :all?
		other.all? {|e| e.eql? 1}
	    else
		other == 1
	    end
	end
	alias == eql?

	def coerce(other)
	    if other.is_a? Numeric
		[other, 1]
	    elsif other.is_a? Array
		[other, Array.new(other.size, 1)]
	    elsif other.is_a? Vector
		[other, Vector[*Array.new(other.size, 1)]]
	    else
		[Point[other], Point[Array.new(other.size, 1)]]
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
	    1
	end

	# @attribute [r] x
	#   @return [Numeric] X-component
	def x
	    1
	end

	# @attribute [r] y
	#   @return [Numeric] Y-component
	def y
	    1
	end

	# @attribute [r] z
	#   @return [Numeric] Z-component
	def z
	    1
	end
# @endgroup

# @group Arithmetic

# @group Unary operators
	def +@
	    self
	end

	def -@
	    -1
	end
# @endgroup

	def +(other)
	    case other
		when Numeric
		    Point.iso(other + 1)
		when Size
		    Point[other.map {|a| a + 1 }]
		else
		    if other.respond_to?(:map)
			other.map {|a| a + 1 }
		    else
			Point[other + 1]
		    end
	    end
	end

	def -(other)
	    if other.is_a? Size
		Point[other.map {|a| 1 - a }]
	    elsif other.respond_to? :map
		other.map {|a| 1 - a }
	    elsif other == 1
		Point.zero
	    else
		Point.iso(1 - other)
	    end
	end

	def *(other)
	    raise OperationNotDefined unless other.is_a? Numeric
	    other
	end

	def /(other)
	    raise OperationNotDefined unless other.is_a? Numeric
	    raise ZeroDivisionError if 0 == other
	    1 / other
	end
# @endgroup

	# @group Enumerable

	# Return the first, or first n, elements (always 0)
	# @param n [Number]	the number of elements to return
	def first(n=nil)
	    Array.new(n, 1) rescue 1
	end
	# @endgroup
    end
end

