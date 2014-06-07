require_relative 'cluster_factory'
require_relative 'point'

module Geometry

=begin rdoc
Circles come in all shapes and sizes, but they're usually round.

== Usage
    circle = Geometry::Circle.new [1,2], 3
    circle = Geometry::Circle.new center:[1,2], radius:3
    circle = Geometry::Circle.new center:[1,2], diameter:6
    circle = Geometry::Circle.new diameter:6
=end

    class Circle
	include ClusterFactory

	# @return [Point]   The {Circle}'s center point
	attr_reader :center

	# @return [Number]  The {Circle}'s radius
	attr_reader :radius

	# @overload new(center, radius)
	#   Construct a {Circle} using a centerpoint and radius
	#   @param [Point]	center  The center point of the {Circle}
	#   @param [Number]	radius	The radius of the {Circle}
	# @overload new(center, radius)
	#   Construct a circle using named center and radius parameters
	#   @option options [Point]	:center (PointZero)
	#   @option options [Number]	:radius
	# @overload new(center, diameter)
	#   Construct a circle using named center and diameter parameters
	#   @option options [Point]	:center (PointZero)
	#   @option options [Number]	:diameter
	def self.new(*args, &block)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)
	    center, radius = args[0..1]

	    center ||= (options[:center] || PointZero.new)
	    radius ||= options[:radius]

	    if radius
		self.allocate.tap {|circle| circle.send :initialize, center, radius, &block }
	    elsif options.has_key?(:diameter)
		CenterDiameterCircle.new center, options[:diameter], &block
	    else
		raise ArgumentError, "Circle.new requires a radius or a diameter"
	    end
	end

	# Construct a new {Circle} from a centerpoint and radius
	# @param    [Point]	center  The center point of the {Circle}
	# @param    [Number]	radius  The radius of the {Circle}
	# @return   [Circle]	A new {Circle} object
	def initialize(center, radius)
	    @center = Point[center]
	    @radius = radius
	end

	def eql?(other)
	    (self.center == other.center) && (self.radius == other.radius)
	end
	alias :== :eql?

# @!group Accessors
	# @return [Rectangle]	The smallest axis-aligned {Rectangle} that bounds the receiver
	def bounds
	    return Rectangle.new(self.min, self.max)
	end

	# @!attribute closed?
	#   @return [Bool]  always true
	def closed?
	    true
	end

	# @!attribute [r] diameter
	#   @return [Numeric] The diameter of the {Circle}
	def diameter
	    @radius*2
	end

	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @center+radius
	end

	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @center-radius
	end

	# @return [Array<Point>]    The lower left and upper right corners of the bounding {Rectangle}
	def minmax
	    [self.min, self.max]
	end
# @!endgroup
    end

    class CenterDiameterCircle < Circle
	# @return [Number]  The {Circle}'s diameter
	attr_reader :diameter

	# Construct a new {Circle} from a centerpoint and a diameter
	# @param    [Point]	center  The center point of the {Circle}
	# @param    [Number]	diameter  The radius of the {Circle}
	# @return   [Circle]	A new {Circle} object
	def initialize(center, diameter)
	    @center = Point[center]
	    @diameter = diameter
	end

	def eql?(other)
	    (self.center == other.center) && (self.diameter == other.diameter)
	end
	alias :== :eql?

# @!group Accessors
	# @return [Number] The {Circle}'s radius
	def radius
	    @diameter/2
	end
# @!endgroup
    end
end
