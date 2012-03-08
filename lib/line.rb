require_relative 'point'

module Geometry
    class Line
	def self.[](*args)
	    Geometry.Line(*args)
	end
	def self.horizontal(y_intercept=0)
	    SlopeInterceptLine.new(0, y_intercept)
	end
	def self.vertical(x_intercept=0)
	    SlopeInterceptLine.new(1/0.0, x_intercept)
	end
    end

    class PointSlopeLine < Line
	def initialize(point, slope)
	    @point = point.is_a?(Geometry::Point) ? point : Geometry.Point(point)
	    @slope = slope
	end
	def to_s
	    'Line(' + @slope.to_s + ',' + @point.to_s + ')'
	end
    end

    class SlopeInterceptLine < Line
	def initialize(slope, intercept)
	    @slope = slope
	    @intercept = intercept
	end
	
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
	def slope
	    @slope
	end

	def to_s
	    'Line(' + @slope.to_s + ',' + @intercept.to_s + ')'
	end
    end

    class TwoPointLine < Line
	attr_reader :first, :last

	def initialize(point0, point1)
	    @first, @last = [point0, point1].map {|p| p.is_a?(Point) ? p : Geometry.Point(p) }
	end
	def inspect
	    'Line(' + @first.to_s + ', ' + @last.to_s + ')'
	end
	alias :to_s :inspect
    end

    def self.Line(*args)
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
end

