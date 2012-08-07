require_relative 'point'

module Geometry
=begin rdoc
An object repesenting a {Point} at the origin in N-dimensional space

A {PointZero} object is a {Point} that will always compare equal to zero and unequal to
everything else, regardless of size.
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

    end
end

