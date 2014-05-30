require_relative 'point'

module Geometry
=begin rdoc
An object repesenting a {Size} of 1, in N-dimensional space

A {SizeOne} object is a {Size} that will always compare equal to one and unequal to
everything else, regardless of dimensionality. It's similar to the
{http://en.wikipedia.org/wiki/Null_Object_pattern Null Object Pattern}, but for ones.
=end
    class SizeOne
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
		[other, Array.new(other.size,1)]
	    elsif other.is_a? Vector
		[other, Vector[*Array.new(other.size,1)]]
	    else
		[Size[other], Size[Array.new(other.size,1)]]
	    end
	end

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
	    if other.respond_to?(:map)
		other.map {|a| a + 1 }
	    else
		other + 1
	    end
	end

	def -(other)
	    if other.is_a? Numeric
		1 - other
	    elsif other.respond_to? :map
		other.map {|a| 1 - a }
	    else
		1 - other
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

