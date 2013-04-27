require 'matrix'

module Geometry
    DimensionMismatch = Class.new(StandardError)
    OperationNotDefined = Class.new(StandardError)

=begin rdoc
An object repesenting a Point in N-dimensional space

Supports all of the familiar Vector methods and adds convenience
accessors for those variables you learned to hate in your high school
geometry class (x, y, z).

== Usage

=== Constructor
    point = Geometry::Point[x,y]
=end
    class Point < Vector
	attr_reader :x, :y, :z

	# Allow vector-style initialization, but override to support copy-init
	# from Vector or another Point
	#
	# @overload [](x,y,z,...)
	# @overload [](Array)
	# @overload [](Point)
	# @overload [](Vector)
	def self.[](*array)
	    return array[0] if array[0].is_a? Point
	    array = array[0] if array[0].is_a?(Array)
	    array = array[0].to_a if array[0].is_a?(Vector)
	    super *array
	end

	# Creates and returns a new {PointZero} instance
	# @return [PointZero] A new {PointZero} instance
	def self.zero
	    PointZero.new
	end

	# Allow comparison with an Array, otherwise do the normal thing
	def eql?(other)
	    if other.is_a?(Array)
		@elements.eql? other
	    elsif other.is_a?(PointZero)
		@elements.all? {|e| e.eql? 0 }
	    else
		super other
	    end
	end

	# Allow comparison with an Array, otherwise do the normal thing
	def ==(other)
	    if other.is_a?(Array)
		@elements.eql? other
	    elsif other.is_a?(PointZero)
		@elements.all? {|e| e.eql? 0 }
	    else
		super other
	    end
	end

	# Combined comparison operator
	# @return [Point]   The <=> operator is applied to the elements of the arguments pairwise and the results are returned in a Point
	def <=>(other)
	    Point[self.to_a.zip(other.to_a).map {|a,b| a <=> b}.compact]
	end

	def coerce(other)
	    case other
		when Array then [Point[*other], self]
		when Numeric then [Point[Array.new(self.size, other)], self]
		when Vector then [Point[*other], self]
		else
		    raise TypeError, "#{self.class} can't be coerced into #{other.class}"
	    end
	end

	def inspect
	    'Point' + @elements.inspect
	end
	def to_s
	    'Point' + @elements.to_s
	end

# @group Accessors
	# @param [Integer]  i	Index into the {Point}'s elements
	# @return [Numeric] Element i (starting at 0)
	def [](i)
	    @elements[i]
	end

	# @attribute [r] x
	# @return [Numeric] X-component
	def x
	    @elements[0]
	end

	# @attribute [r] y
	# @return [Numeric] Y-component
	def y
	    @elements[1]
	end

	# @attribute [r] z
	# @return [Numeric] Z-component
	def z
	    @elements[2]
	end
# @endgroup

# @group Arithmetic

# @group Unary operators
	def +@
	    self
	end

	def -@
	    Point[@elements.map {|e| -e }]
	end
# @endgroup

	def +(other)
	    case other
		when Numeric
		    Point[@elements.map {|e| e + other}]
		when PointZero
		    self
		else
		    raise OperationNotDefined, "#{other.class} must respond to :size and :[]" unless other.respond_to?(:size) && other.respond_to?(:[])
		    raise DimensionMismatch,  "Can't add #{other} to #{self}" if size != other.size
		    Point[Array.new(size) {|i| @elements[i] + other[i] }]
	    end
	end

	def -(other)
	    case other
		when Numeric
		    Point[@elements.map {|e| e - other}]
		when PointZero
		    self
		else
		    raise OperationNotDefined, "#{other.class} must respond to :size and :[]" unless other.respond_to?(:size) && other.respond_to?(:[])
		    raise DimensionMismatch, "Can't subtract #{other} from #{self}" if size != other.size
		    Point[Array.new(size) {|i| @elements[i] - other[i] }]
	    end
	end

# @endgroup

    end
end

