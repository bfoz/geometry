require_relative 'point'

module Geometry

=begin rdoc
Circles come in all shapes and sizes, but they're usually round.
 
== Usage
    circle = Geometry::Circle [1,1], 2
=end
    
    class Circle
	attr_reader :center, :radius
	
	# Construct a new {Circle} from a centerpoint and radius
	# @param    [Point]	center  The center point of the Circle
	# @param    [Number]	radius  The radius of the Circle
	# @return   [Circle]	A new Circle object
	def initialize(center, radius)
	    @center = center.is_a?(Point) ? center : Point[center]
	    @radius = radius
	end
    end
end
