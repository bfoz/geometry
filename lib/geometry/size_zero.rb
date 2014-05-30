require_relative 'point'

module Geometry
=begin rdoc
An object repesenting a zero {Size} in N-dimensional space

A {SizeZero} object is a {Size} that will always compare equal to zero and unequal to
everything else, regardless of dimensionality. You can think of it as an application of the
{http://en.wikipedia.org/wiki/Null_Object_pattern Null Object Pattern}.
=end
    class SizeZero
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
		[Size[other], Size[Array.new(other.size,0)]]
	    end
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
	    other
	end

	def -(other)
	    if other.respond_to? :-@
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

