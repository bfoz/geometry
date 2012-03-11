require_relative 'geometry/point'
require_relative 'geometry/line'

module Geometry
    # @overload Line(array0, array1)
    #   @param [Array] array0 First endpoint
    #   @param [Array] array1 Second endpoint
    #   @return [TwoPointLine]
    # @overload Line(point0, point1)
    #   @param [Point] point0 First endpoint
    #   @param [Point] point1 Second endpoint
    #   @return [TwoPointLine]
    # @overload Line(vector0, vector1)
    #   @param [Vector] vector0 First endpoint
    #   @param [Vector] vector1 Second endpoint
    #   @return [TwoPointLine]
    # @overload Line(y_intercept, slope)
    #   @param [Numeric] y_intercept Y-intercept
    #   @param [Numeric] slope Slope
    #   @return [SlopeInterceptLine]
    # @overload Line(point, slope)
    #   @param [Point] point Starting point
    #   @param [Numeric] slope Slope
    #   @return [PointSlopeLine]
    def self.Line(*args)
	Geometry::Line[*args]
    end

    # @overload Point(x,y,z,...)
    #   @return [Point]
    # @overload Point(Point)
    #   @return [Point]
    # @overload Point(Vector)
    #   @return [Point]
    def self.Point(*args)
	Geometry::Point[*args]
    end
end
