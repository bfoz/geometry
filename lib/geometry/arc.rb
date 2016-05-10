require_relative 'point'

require_relative 'cluster_factory'
require_relative 'point'

module Geometry

=begin rdoc
{http://en.wikipedia.org/wiki/Arc_(geometry) Arcs} are Circles that don't quite go all the way around

== Usage
An {Arc} with its center at [1,1] and a radius of 2 that starts at the X-axis and goes to the Y-axis (counter-clockwise)
    arc = Geometry::Arc.new center:[1,1], radius:2, start:0, end:90
=end

    class Arc
	include ClusterFactory

	attr_reader :center

	# @return [Number]  the radius of the {Arc}
	attr_reader :radius

	# @return [Number]  the starting angle of the {Arc} as radians from the x-axis
	attr_reader :start_angle

	# @return [Number]  the ending angle of the {Arc} as radians from the x-axis
	attr_reader :end_angle

	# @overload new(center, start, end)
	#  Create a new {Arc} given center, start and end {Point}s
	# @option options [Point] :center (PointZero)   The {Point} at the center
	# @option options [Point] :start    The {Arc} starts at the start {Point}
	# @option options [Point] :end	    The {Point} where it all ends
	# @return [Arc]
	# @overload new(center, radius, start, end)
	#  Create a new {Arc} given a center {Point}, a radius and start and end angles
	# @option options [Point]   :center (PointZero)	The {Point} at the center of it all
	# @option options [Numeric] :radius	Radius
	# @option options [Numeric] :start	Starting angle
	# @option options [Numeric] :end	Ending angle
	# @return [ThreePointArc]
	def self.new(options={})
	    center = options.delete(:center) || PointZero.new

	    if options.has_key?(:radius)
		original_new(center, options[:radius], options[:start], options[:end])
	    else
		ThreePointArc.new(center, options[:start], options[:end])
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

	def ==(other)
	    if other.is_a?(ThreePointArc)
		(self.center == other.center) && (self.end == other.end) && (self.start == other.start)
	    else
		super other
	    end
	end

    # @group Attributes

	# @return [Point]   The upper-right corner of the bounding rectangle that encloses the {Path}
	def max
	    minmax.last
	end

	# @return [Point]   The lower-left corner of the bounding rectangle that encloses the {Path}
	def min
	    minmax.first
	end

	# @return [Array<Point>]    The lower-left and upper-right corners of the enclosing bounding rectangle
	def minmax
	    a = [self.start, self.end]
	    quadrants = a.map(&:quadrant)

	    # If the Arc spans more than one quadrant, then it must cross at
	    #  least one axis. Each axis-crossing is a potential extrema.
	    if quadrants.first != quadrants.last
		range = (quadrants.first...quadrants.last)
		# If the Arc crosses the X axis...
		if quadrants.first > quadrants.last
		    range = (quadrants.first..4).to_a + (1...quadrants.last).to_a
		end

		a = range.map do |q|
		    case q
			when 1 then self.center + Point[0,radius]
			when 2 then self.center + Point[-radius, 0]
			when 3 then self.center + Point[0,-radius]
			when 4 then self.center + Point[radius,0]
		    end
		end.push(*a)
		a.reduce([a.first, a.first]) {|memo, e| [memo.first.min(e), memo.last.max(e)] }
	    else
		[a.first.min(a.last), a.first.max(a.last)]
	    end
	end

	def end_angle
	    a = (self.end - self.center)
	    Math.atan2(a.y, a.x)
	end

	def radius
	    (self.start - self.center).magnitude
	end

	def start_angle
	    a = (self.start - self.center)
	    Math.atan2(a.y, a.x)
	end

    # @endgroup
    end
end
