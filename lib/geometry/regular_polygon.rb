require_relative 'polygon'

module Geometry
=begin rdoc
A {RegularPolygon} is a lot like a {Polygon}, but more regular.

{http://en.wikipedia.org/wiki/Regular_polygon}

== Usage
    polygon = Geometry::RegularPolygon.new sides:4, center:[1,2], radius:3
    polygon = Geometry::RegularPolygon.new sides:6, center:[1,2], diameter:6

    polygon = Geometry::RegularPolygon.new sides:4, center:[1,2], inradius:3
    polygon = Geometry::RegularPolygon.new sides:6, center:[1,2], indiameter:6
=end

    class RegularPolygon < Polygon
	# @return [Point]   The {RegularPolygon}'s center point
	attr_reader :center

	# @return [Number]  The {RegularPolygon}'s number of sides
	attr_reader :edge_count

	# @overload new(sides, center, radius)
	#   Construct a {RegularPolygon} using a center point and radius
	#   @option options [Number]	:sides	The number of edges
	#   @option options [Point]	:center	(PointZero) The center point of the {RegularPolygon}
	#   @option options [Number]	:radius The circumradius of the {RegularPolygon}
	# @overload new(sides, center, inradius)
	#   Construct a {RegularPolygon} using a center point and radius
	#   @option options [Number]	:sides	The number of edges
	#   @option options [Point]	:center	(PointZero) The center point of the {RegularPolygon}
	#   @option options [Number]	:inradius   The inradius of the {RegularPolygon}
	# @overload new(sides, center, diameter)
	#   Construct a {RegularPolygon} using a center point and diameter
	#   @option options [Number]	:sides  The number of edges
	#   @option options [Point]	:center	(PointZero) The center point of the {RegularPolygon}
	#   @option options [Number]	:diameter   The circumdiameter of the {RegularPolygon}
	# @overload new(sides, center, indiameter)
	#   Construct a {RegularPolygon} using a center point and diameter
	#   @option options [Number]	:sides  The number of edges
	#   @option options [Point]	:center	(PointZero) The center point of the {RegularPolygon}
	#   @option options [Number]	:indiameter   The circumdiameter of the {RegularPolygon}
	# @return   [RegularPolygon]	A new {RegularPolygon} object
	def initialize(edge_count:nil, sides:nil, center:nil, radius:nil, diameter:nil, indiameter:nil, inradius:nil)
	    @edge_count = edge_count || sides
	    raise ArgumentError, "RegularPolygon requires an edge count" unless @edge_count

	    raise ArgumentError, "RegularPolygon.new requires a radius or a diameter" unless diameter || indiameter || inradius || radius

	    @center = center ? Point[center] : Point.zero
	    @diameter = diameter
	    @indiameter = indiameter
	    @inradius = inradius
	    @radius = radius
	end

	def eql?(other)
	    (self.center == other.center) && (self.edge_count == other.edge_count) && (self.radius == other.radius)
	end
	alias :== :eql?

	# Check to see if the {Polygon} is closed (always true)
	# @return [True] Always true because a {Polygon} is always closed
	def closed?
	    true
	end

# @!group Accessors
	# @return [Rectangle]	The smallest axis-aligned {Rectangle} that bounds the receiver
	def bounds
	    return Rectangle.new(self.min, self.max)
	end

	# @!attribute [r] diameter
	#   @return [Numeric] The diameter of the {RegularPolygon}
	def diameter
	    @diameter || (@radius && 2*@radius) || (@indiameter && @indiameter/cosine_half_angle)
	end
	alias :circumdiameter :diameter

	# !@attribute [r] edges
	def edges
	    points = self.vertices
	    points.each_cons(2).map {|p1,p2| Edge.new(p1,p2) } + [Edge.new(points.last, points.first)]
	end

	# !@attribute [r] vertices
	#   @return [Array]
	def vertices
	    (0...2*Math::PI).step(2*Math::PI/edge_count).map {|angle| center + Point[Math::cos(angle), Math::sin(angle)]*radius }
	end
	alias :points :vertices

	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @center+Point[radius, radius]
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @center-Point[radius, radius]
	end

	# @return [Array<Point>]    The lower left and upper right corners of the bounding {Rectangle}
	def minmax
	    [self.min, self.max]
	end

	# @!attribute indiameter
	#   @return [Number]  the indiameter
	def indiameter
	    @indiameter || (@inradius && 2*@inradius) || (@diameter && (@diameter * cosine_half_angle)) || (@radius && (2 * @radius * cosine_half_angle))
	end

	# @!attribute inradius
	#   @return [Number]  The inradius
	def inradius
	    @inradius || (@indiameter && @indiameter/2) || (@radius && (@radius * cosine_half_angle))
	end
	alias :apothem :inradius

	# @!attribute [r] radius
	# @return [Number]  The {RegularPolygon}'s radius
	def radius
	    @radius || (@diameter && @diameter/2) || (@inradius && (@inradius / cosine_half_angle)) || (@indiameter && @indiameter/cosine_half_angle/2)
	end
	alias :circumradius :radius

	# @!attribute [r] side_length
	#   @return [Number]  The length of each side
	def side_length
	    2 * circumradius * Math.sin(Math::PI/edge_count)
	end

private
	def cosine_half_angle
	    Math.cos(Math::PI/edge_count)
	end

# @!endgroup
    end
end
