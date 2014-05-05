require_relative 'point'

module Geometry
=begin rdoc
An object repesenting a N-dimensional {Point} with identical elements.
=end
    class PointIso
	# @!attribute value
	#   @return [Number]  the value for every element
	attr_accessor :value

	# Initialize to the given value
	# @param value [Number]	the value for every element of the new {PointIso}
 	def initialize(value)
	    @value = value
	end

	def eql?(other)
	    if other.respond_to? :all?
		other.all? {|e| e.eql? @value}
	    else
		other == @value
	    end
	end
	alias == eql?

	def coerce(other)
	    if other.is_a? Numeric
		[other, @value]
	    elsif other.is_a? Array
		[other, Array.new(other.size, @value)]
	    elsif other.is_a? Vector
		[other, Vector[*Array.new(other.size, @value)]]
	    else
		[Point[other], Point[Array.new(other.size, @value)]]
	    end
	end

	def inspect
	    'PointIso<' + @value.inspect + '>'
	end
	def to_s
	    'PointIso<' + @value.to_s + '>'
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
	# @param i [Integer]	Index into the {Point}'s elements
	# @return [Numeric] Element i (starting at 0)
	def [](i)
	    @value
	end

	# @attribute [r] x
	#   @return [Numeric] X-component
	def x
	    @value
	end

	# @attribute [r] y
	#   @return [Numeric] Y-component
	def y
	    @value
	end

	# @attribute [r] z
	#   @return [Numeric] Z-component
	def z
	    @value
	end
# @endgroup

# @group Arithmetic

# @group Unary operators
	def +@
	    self
	end

	def -@
	    self.class.new(-@value)
	end
# @endgroup

	def +(other)
	    case other
		when Numeric
		    other + @value
		when Size
		    Point[other.map {|a| a + @value }]
		else
		    if other.respond_to?(:map)
			other.map {|a| a + @value }
		    else
			Point[other + @value]
		    end
	    end
	end

	def -(other)
	    if other.is_a? Size
		Point[other.map {|a| @value - a }]
	    elsif other.respond_to? :map
		other.map {|a| @value - a }
	    else
		@value - other
	    end
	end

	def *(other)
	    raise OperationNotDefined unless other.is_a? Numeric
	    self.class.new(other * @value)
	end

	def /(other)
	    raise OperationNotDefined unless other.is_a? Numeric
	    raise ZeroDivisionError if 0 == other
	    self.class.new(@value / other)
	end
# @endgroup

    end
end

