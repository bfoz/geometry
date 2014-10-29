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

    # @private
    class PointSlopeLine < Line
	# @!attribute point
	#   @return [Point]  the stating point
	attr_reader :point

	# @return [Number]  the slope of the {Line}
	attr_reader :slope

	def initialize(point, slope)
	    @point = Point[point]
	    @slope = slope
	end

	# Two {PointSlopeLine}s are equal if both have equal slope and origin
	def ==(other)
	    (point == other.point) && (slope == other.slope)
	end
	alias :eql? :==

	def to_s
	    'Line(' + @slope.to_s + ',' + @point.to_s + ')'
	end
    end

    # @private
    class SlopeInterceptLine < Line
	# @return [Number]  the slope of the {Line}
	attr_reader :slope

	def initialize(slope, intercept)
	    @slope = slope
	    @intercept = intercept
	end

	# Two {SlopeInterceptLine}s are equal if both have equal slope and intercept
	def ==(other)
	    (intercept == other.intercept) && (slope == other.slope)
	end
	alias :eql? :==

	def horizontal?
	    0 == @slope
	end
	def vertical?
	    (1/0.0) == @slope
	end

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
	attr_reader :first, :last

	def initialize(point0, point1)
	    @first, @last = [Point[point0], Point[point1]]
	end
	def inspect
	    'Line(' + @first.inspect + ', ' + @last.inspect + ')'
	end
	alias :to_s :inspect

	# Two {TwoPointLine}s are equal if both have equal {Point}s in the same order
	def ==(other)
	    (first == other.first) && (last == other.last)
	end
	alias :eql? :==

# @group Accessors
	# !@attribute [r[ slope
	#   @return [Number]	the slope of the {Line}
	def slope
	    (last.y - first.y)/(last.x - first.x)
	end
# @endgroup
    end
end

