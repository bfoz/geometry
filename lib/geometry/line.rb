require_relative 'cluster_factory'
require_relative 'point'

module Geometry

=begin rdoc
A cluster of objects representing a Line of infinite length

Supports two-point, slope-intercept, and point-slope initializer forms

== Usage

=== Two-point constructors
    line = Geometry::Line[[0,0], [10,10]]
    line = Geometry::Line[Geometry::Point[0,0], Geometry::Point[10,10]]
    line = Geometry::Line[Vector[0,0], Vector[10,10]]

=== Slope-intercept constructors
    Geometry::Line[Rational(3,4), 5]	# Slope = 3/4, Intercept = 5
    Geometry::Line[0.75, 5]

=== Point-slope constructors
    Geometry::Line(Geometry::Point[0,0], 0.75)
    Geometry::Line(Vector[0,0], Rational(3,4))

===  Special constructors (2D only)
    Geometry::Line.horizontal(y=0)
    Geometry::Line.vertical(x=0)
=end

    class Line
	include ClusterFactory

	# @!attribute [r] horizontal?
	#   @return [Boolean]	true if the slope is zero

	# @!attribute [r] slope
	#   @return [Number]	the slope of the {Line}

	# @!attribute [r] vertical?
	#   @return [Boolean]	true if the slope is infinite

	# @overload [](Array, Array)
	#   @return [TwoPointLine]
	# @overload [](Point, Point)
	#   @return [TwoPointLine]
	# @overload [](Vector, Vector)
	#   @return [TwoPointLine]
	# @overload [](y-intercept, slope)
	#   @return [SlopeInterceptLine]
	# @overload [](point, slope)
	#   @return [PointSlopeLine]
	def self.[](*args)
	    if( 2 == args.size )
		args.map! {|x| x.is_a?(Array) ? Point[*x] : x}

		# If both args are Points, create a TwoPointLine
		return TwoPointLine.new(*args) if args.all? {|x| x.is_a?(Vector)}

		# If only the first arg is a Point, create a PointSlopeLine
		return PointSlopeLine.new(*args) if args.first.is_a?(Vector)

		# Otherise, create a SlopeInterceptLine
		return SlopeInterceptLine.new(*args)
	    else
		nil
	    end
	end

	# @overload new(from, to)
	# @option options [Point] :from	A starting {Point}
	# @option options [Point] :to	An end {Point}
	# @return [TwoPointLine]
	# @overload new(start, end)
	# @option options [Point] :start	A starting {Point}
	# @option options [Point] :end	An end {Point}
	# @return [TwoPointLine]
	def self.new(options={})
	    from = options[:from] || options[:start]
	    to = options[:end] || options[:to]

	    if from and to
		TwoPointLine.new(from, to)
	    else
		raise ArgumentError, "Start and end Points must be provided"
	    end
	end

	def self.horizontal(y_intercept=0)
	    SlopeInterceptLine.new(0, y_intercept)
	end
	def self.vertical(x_intercept=0)
	    SlopeInterceptLine.new(1/0.0, x_intercept)
	end
    end

    module SlopedLine
	# @!attribute slope
	#   @return [Number]  the slope of the {Line}
	attr_reader :slope

	# @!attribute horizontal?
	#   @return [Boolean]  true if the slope is zero
	def horizontal?
	    slope.zero?
	end

	# @!attribute vertical?
	#   @return [Boolean]  true if the slope is infinite
	def vertical?
	    slope.infinite? != nil
	rescue	# Non-Float's don't have an infinite? method
	    false
	end
    end

    # @private
    class PointSlopeLine < Line
	include SlopedLine

	# @!attribute point
	#   @return [Point]  the stating point
	attr_reader :point

	# @param point	[Point]	    a {Point} that lies on the {Line}
	# @param slope	[Number]    the slope of the {Line}
	def initialize(point, slope)
	    @point = Point[point]
	    @slope = slope
	end

	# Two {PointSlopeLine}s are equal if both have equal slope and origin
	def ==(other)
	    case other
		when SlopeInterceptLine
		    # Check that the slopes are equal and that the starting point will solve the slope-intercept equation
		    (slope == other.slope) && (point.y == other.slope * point.x + other.intercept)
		when TwoPointLine
		    # Plug both of other's endpoints into the line equation and check that they solve it
		    first_diff = other.first - point
		    last_diff = other.last - point
		    (first_diff.y == slope*first_diff.x) && (last_diff.y == slope*last_diff.x)
		else
		    self.eql? other
	    end
	end

	# Two {PointSlopeLine}s are equal if both have equal slopes and origins
	#   @note eql? does not check for equivalence between cluster subclases
	def eql?(other)
	    (point == other.point) && (slope == other.slope)
	end

	def to_s
	    'Line(' + @slope.to_s + ',' + @point.to_s + ')'
	end

	# Find the requested axis intercept
	# @param axis	[Symbol]    the axis to intercept (either :x or :y)
	# @return [Number]  the location of the intercept
	def intercept(axis=:y)
	    case axis
		when :x
		    vertical? ? point.x : (horizontal? ? nil : (slope * point.x - point.y))
		when :y
		    vertical? ? nil : (horizontal? ? point.y : (point.y - slope * point.x))
	    end
	end
    end

    # @private
    class SlopeInterceptLine < Line
	include SlopedLine

	# @param slope	    [Number]    the slope
	# @param intercept  [Number]	the location of the y-axis intercept
	def initialize(slope, intercept)
	    @slope = slope
	    @intercept = intercept
	end

	# Two {SlopeInterceptLine}s are equal if both have equal slope and intercept
	def ==(other)
	    case other
		when PointSlopeLine
		    # Check that the slopes are equal and that the starting point will solve the slope-intercept equation
		    (slope == other.slope) && (other.point.y == slope * other.point.x + intercept)
		when TwoPointLine
		    # Check that both endpoints solve the line equation
		    ((other.first.y == slope * other.first.x + intercept)) && (other.last.y == (slope * other.last.x + intercept))
		else
		    self.eql? other
		end
	end

	# Two {SlopeInterceptLine}s are equal if both have equal slopes and intercepts
	#   @note eql? does not check for equivalence between cluster subclases
	def eql?(other)
	    (intercept == other.intercept) && (slope == other.slope)
	end

	# Find the requested axis intercept
	# @param axis	[Symbol]    the axis to intercept (either :x or :y)
	# @return [Number]  the location of the intercept
	def intercept(axis=:y)
	    case axis
		when :x
		    vertical? ? @intercept : (horizontal? ? nil : (-@intercept/@slope))
		when :y
		    vertical? ? nil : @intercept
	    end
	end

	def to_s
	    'Line(' + @slope.to_s + ',' + @intercept.to_s + ')'
	end
    end

    # @private
    class TwoPointLine < Line
	# @!attribute first
	#   @return [Point]  the {Line}'s starting point
	attr_reader :first

	# @!attribute last
	#   @return [Point]  the {Line}'s end point
	attr_reader :last

	# @param first	[Point]	the starting point
	# @param last	[Point]	the end point
	def initialize(first, last)
	    @first = Point[first]
	    @last = Point[last]
	end

	def inspect
	    'Line(' + @first.inspect + ', ' + @last.inspect + ')'
	end
	alias :to_s :inspect

	# Two {TwoPointLine}s are equal if both have equal {Point}s in the same order
	def ==(other)
	    case other
		when PointSlopeLine
		    # Plug both endpoints into the line equation and check that they solve it
		    first_diff = first - other.point
		    last_diff = last - other.point
		    (first_diff.y == other.slope*first_diff.x) && (last_diff.y == other.slope*last_diff.x)
		when SlopeInterceptLine
		    # Check that both endpoints solve the line equation
		    ((first.y == other.slope * first.x + other.intercept)) && (last.y == (other.slope * last.x + other.intercept))
		else
		    self.eql?(other) || ((first == other.last) && (last == other.first))
		end
	end

	# Two {TwoPointLine}s are equal if both have equal endpoints
	#   @note eql? does not check for equivalence between cluster subclases
	def eql?(other)
	    (first == other.first) && (last == other.last)
	end

# @group Accessors
	# !@attribute [r[ slope
	#   @return [Number]	the slope of the {Line}
	def slope
	    (last.y - first.y)/(last.x - first.x)
	end

	def horizontal?
	    first.y == last.y
	end

	def vertical?
	    first.x == last.x
	end

	# Find the requested axis intercept
	# @param axis	[Symbol]    the axis to intercept (either :x or :y)
	# @return [Number]  the location of the intercept
	def intercept(axis=:y)
	    case axis
		when :x
		    vertical? ? first.x : (horizontal? ? nil : (first.x - first.y/slope))
		when :y
		    vertical? ? nil : (horizontal? ? first.y : (first.y - slope * first.x))
	    end
	end

# @endgroup
    end
end

