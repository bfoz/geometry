require_relative 'point'

module Geometry

=begin rdoc
Arcs are Circles that don't quite go all the way around

== Usage
An {Arc} with its center at [1,1] and a radius of 2 that starts at the X-axis and goes to the Y-axis (counter-clockwise)
    arc = Geometry::Arc.new [1,1], 2, 0, 90
=end

    class Arc
	attr_reader :center
	attr_reader :radius
	attr_reader :start_angle, :end_angle

	# Construct a new {Arc}
	# @overload initialize(center, radius, start_angle, end_angle)
	# @param [Point]    center	The {Point} at the center of it all
	# @param [Numeric]  radius	Radius
	# @param [Numeric]  start_angle	Starting angle
	# @param [Numeric]  end_angle	Ending angle
	def initialize(center, radius, start_angle, end_angle)
	    @center = Point[center]
	    @radius = radius
	    @start_angle = start_angle
	    @end_angle = end_angle
	end
    end
end
