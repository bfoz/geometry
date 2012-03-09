require_relative 'geometry/point'
require_relative 'geometry/line'

module Geometry
    # :call-seq:
    #   Line[Array, Array]	    -> TwoPointLine
    #   Line[Point, Point]	    -> TwoPointLine
    #   Line[Vector, Vector]	    -> TwoPointLine
    #   Line[y-intercept, slope]    -> SlopeInterceptLine
    #   Line[point, slope]	    -> PointSlopeLine
    def self.Line(*args)
	Geometry::Line[*args]
    end

    # :call-seq:
    #   Point[x,y,z,...]
    #   Point[Point]
    #   Point[Vector]
    def self.Point(*args)
	Geometry::Point[*args]
    end
end
