module Geometry
=begin
Bézier curves are like lines, but curvier.

http://en.wikipedia.org/wiki/Bézier_curve

== Constructors

    Bezier.new [0,0], [1,1], [2,2]  # From control points

== Usage

To get a point on the curve for a particular value of t, you can use the subscript operator

    bezier[0.5]	# => [1,1]
=end
    class Bezier
	# @!attribute degree
	#   @return [Number]  The degree of the curve
	def degree
	    points.length - 1
	end

	# @!attribute points
	#   @return [Array<Point>]  The control points for the Bézier curve
	attr_reader :points

	def initialize(*points)
	    @points = points.map {|v| Point[v]}
	end

	# http://en.wikipedia.org/wiki/Binomial_coefficient
	# http://rosettacode.org/wiki/Evaluate_binomial_coefficients#Ruby
	def binomial_coefficient(k)
	    (0...k).inject(1) {|m,i| (m * (degree - i)) / (i + 1) }
	end

	# @param t [Float]  the input parameter
	def [](t)
	    return nil unless (0..1).include?(t)
	    result = Point.zero(points.first.size)
	    points.each_with_index do |v, i|
		result += v * binomial_coefficient(i) * ((1 - t) ** (degree - i)) * (t ** i)
	    end
	    result
	end
    end
end