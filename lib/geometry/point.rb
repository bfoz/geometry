require 'matrix'

require_relative 'point_iso'
require_relative 'point_one'
require_relative 'point_zero'

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
	    return array[0] if array[0].is_a?(Point)
	    array = array[0] if array[0].is_a?(Array)
	    array = array[0].to_a if array[0].is_a?(Vector)
	    super *array
	end

	# Creates and returns a new {PointIso} instance. Or, a {Point} full of ones if the size argument is given.
	# @param value [Number]	the value of the elements
	# @param size [Number] the size of the new {Point} full of ones
	# @return [PointIso] A new {PointIso} instance
	def self.iso(value, size=nil)
	    size ? Point[Array.new(size, 1)] : PointIso.new(value)
	end

	# Creates and returns a new {PointOne} instance. Or, a {Point} full of ones if the size argument is given.
	# @param size [Number] the size of the new {Point} full of ones
	# @return [PointOne] A new {PointOne} instance
	def self.one(size=nil)
	    size ? Point[Array.new(size, 1)] : PointOne.new
	end

	# Creates and returns a new {PointZero} instance. Or, a {Point} full of zeros if the size argument is given.
	# @param size [Number] the size of the new {Point} full of zeros
	# @return [PointZero] A new {PointZero} instance
	def self.zero(size=nil)
	    size ? Point[Array.new(size, 0)] : PointZero.new
	end

	# Return a copy of the {Point}
	def clone
	    Point[@elements.clone]
	end

	# Allow comparison with an Array, otherwise do the normal thing
	def eql?(other)
	    if other.is_a?(Array)
		@elements.eql? other
	    elsif other.is_a?(PointIso)
		value = other.value
		@elements.all? {|e| e.eql? value }
	    elsif other.is_a?(PointOne)
		@elements.all? {|e| e.eql? 1 }
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
	    elsif other.is_a?(PointIso)
		value = other.value
		@elements.all? {|e| e.eql? value }
	    elsif other.is_a?(PointOne)
		@elements.all? {|e| e.eql? 1 }
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

	# @override max()
	# @return [Number]  The maximum value of the {Point}'s elements
	# @override max(point)
	# @return [Point]    The element-wise maximum values of the receiver and the given {Point}
	def max(*args)
	    if args.empty?
		@elements.max
	    else
		args = args.first if 1 == args.size
		case args
		    when PointIso   then    self.class[@elements.map {|e| [e, args.value].max }]
		    when PointOne   then    self.class[@elements.map {|e| [e, 1].max }]
		    when PointZero  then    self.class[@elements.map {|e| [e, 0].max }]
		    else
			self.class[@elements.zip(args).map(&:max)]
		end
	    end
	end

	# @override min()
	# @return [Number]  The minimum value of the {Point}'s elements
	# @override min(point)
	# @return [Point]    The element-wise minimum values of the receiver and the given {Point}
	def min(*args)
	    if args.empty?
		@elements.min
	    else
		args = args.first if 1 == args.size
		case args
		    when PointIso   then    self.class[@elements.map {|e| [e, args.value].min }]
		    when PointOne   then    self.class[@elements.map {|e| [e, 1].min }]
		    when PointZero  then    self.class[@elements.map {|e| [e, 0].min }]
		    else
			self.class[@elements.zip(args).map(&:min)]
		end
	    end
	end

	# @override minmax()
	# @return [Array<Number>]   The minimum value of the {Point}'s elements
	# @override min(point)
	# @return [Array<Point>]    The element-wise minimum values of the receiver and the given {Point}
	def minmax(*args)
	    if args.empty?
		@elements.minmax
	    else
		[min(*args), max(*args)]
	    end
	end

	# Returns a new {Point} with the given number of elements removed from the end
	# @return [Point]   the popped elements
	def pop(count=1)
	    self.class[to_a.pop(count)]
	end

	# Returns a new {Point} with the given elements appended
	# @return [Point]
	def push(*args)
	    self.class[to_a.push(*args)]
	end

	# Removes the first element and returns it
	# @return [Point]   the shifted elements
	def shift(count=1)
	    self.class[to_a.shift(count)]
	end

	# Prepend the given objects and return a new {Point}
	# @return [Point]
	def unshift(*args)
	    self.class[to_a.unshift(*args)]
	end

# @group Accessors
	# @param [Integer]  i	Index into the {Point}'s elements
	# @return [Numeric] Element i (starting at 0)
	def [](*args)
	    @elements[*args]
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
		when PointIso
		    value = other.value
		    Point[@elements.map {|e| e + value}]
		when PointOne
		    Point[@elements.map {|e| e + 1}]
		when PointZero, NilClass
		    self.dup
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
		when PointIso
		    value = other.value
		    Point[@elements.map {|e| e - value}]
		when PointOne
		    Point[@elements.map {|e| e - 1}]
		when PointZero, NilClass
		    self.dup
		else
		    raise OperationNotDefined, "#{other.class} must respond to :size and :[]" unless other.respond_to?(:size) && other.respond_to?(:[])
		    raise DimensionMismatch, "Can't subtract #{other} from #{self}" if size != other.size
		    Point[Array.new(size) {|i| @elements[i] - other[i] }]
	    end
	end

	def *(other)
	    case other
		when NilClass
		    nil
		when Numeric
		    Point[@elements.map {|e| e * other}]
		when PointZero
		    Point.zero
		else
		    if other.respond_to?(:[])
			raise OperationNotDefined, "#{other.class} must respond to :size" unless other.respond_to?(:size)
			raise DimensionMismatch, "Can't multiply #{self} by #{other}" if size != other.size
			Point[Array.new(size) {|i| @elements[i] * other[i] }]
		    else
			Point[@elements.map {|e| e * other}]
		    end
	    end
	end

	def /(other)
	    case other
		when Matrix, Vector, Point, Size, NilClass, PointZero, SizeZero
		    raise OperationNotDefined, "Can't divide #{self} by #{other}"
		else
		    Point[@elements.map {|e| e / other}]
	    end
	end
# @endgroup

    end
end

