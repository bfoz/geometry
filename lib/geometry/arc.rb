require_relative 'point'

require_relative 'cluster_factory'
require_relative 'point'

module Geometry

=begin rdoc
Arcs are Circles that don't quite go all the way around

== Usage
An {Arc} with its center at [1,1] and a radius of 2 that starts at the X-axis and goes to the Y-axis (counter-clockwise)
    arc = Geometry::Arc.new [1,1], 2, 0, 90
=end

    class Arc
	include ClusterFactory

	attr_reader :center
	attr_reader :radius
	attr_reader :start_angle, :end_angle

	# @overload new(center_point, start_point, end_point)
	#  Create a new {Arc} given center, start and end {Point}s
	# @param [Point]    center_point    The {Point} at the center
	# @param [Point]    start_point	    The {Arc} starts at the start {Point}
	# @param [Point]    end_point	    The {Point} where it all ends
	# @overload initialize(center, radius, start_angle, end_angle)
	#  Create a new {Arc} given a center, a radius and start and end angles
	# @param [Point]    center	The {Point} at the center of it all
	# @param [Numeric]  radius	Radius
	# @param [Numeric]  start_angle	Starting angle
	# @param [Numeric]  end_angle	Ending angle
	def self.new(*args)
	    if 4 == args.size
		original_new(*args)
	    elsif 3 == args.size
		ThreePointArc.new(*args)
	    end
	end

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

	# @return [Point]   The starting point of the {Arc}
	def first
	    @center + @radius * Vector[Math.cos(@start_angle), Math.sin(@start_angle)]
	end

	# @return [Point]   The end point of the {Arc}
	def last
	    @center + @radius * Vector[Math.cos(@end_angle), Math.sin(@end_angle)]
	end
    end

    class ThreePointArc < Arc
	attr_reader :center
	attr_reader :start, :end

	# Contruct a new {Arc} given center, start and end {Point}s
	#  Always assumes that the {Arc} is counter-clockwise. Reverse the order
	#  of the start and end points to get an {Arc} that goes around the other way.
	# @overload initialize(center_point, start_point, end_point)
	# @param [Point]    center_point    The {Point} at the center
	# @param [Point]    start_point	    The {Arc} starts at the start {Point}
	# @param [Point]    end_point	    The {Point} where it all ends
	def initialize(center_point, start_point, end_point)
	    @center, @start, @end = [center_point, start_point, end_point].map {|p| Point[p]}
	    raise ArgumentError unless [@center, @start, @end].all? {|p| p.is_a?(Point)}
	end

	# The starting point of the {Arc}
	# @return [Point]
	alias :first :start

	# The end point of the {Arc}
	# @return [Point]
	alias :last :end
    end
end
