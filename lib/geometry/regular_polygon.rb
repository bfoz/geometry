require_relative 'cluster_factory'
require_relative 'polygon'

module Geometry
=begin rdoc
 A {RegularPolygon} is a lot like a {Polygon}, but more regular.

 {http://en.wikipedia.org/wiki/Regular_polygon}

== Usage
    polygon = Geometry::RegularPolygon.new [1,2], 3
    polygon = Geometry::RegularPolygon.new [1,2], :radius => 3
    polygon = Geometry::RegularPolygon.new [1,2], :diameter => 6
    polygon = Geometry::RegularPolygon.new :center => [1,2], :diameter => 6
=end

    class RegularPolygon < Polygon
	include ClusterFactory

	# @return [Point]   The {RegularPolygon}'s center point
	attr_reader :center

	# @return [Number]  The {RegularPolygon}'s number of sides
	attr_reader :edge_count

	# @return [Number]  The {RegularPolygon}'s radius
	attr_reader :radius

	# @overload new(edge_count, center, radius)
	#   Construct a {RegularPolygon} using a centerpoint and radius
	#   @param [Number]	edge_count  The number of edges
	#   @param [Point]	center  The center point of the {RegularPolygon}
	#   @param [Number]	radius	The radius of the {RegularPolygon}
	# @overload new(edge_count, options)
	#   Construct a {RegularPolygon} using named center and radius parameters
	#   @param [Number]	edge_count  The number of edges
	#   @option options [Point]	:center
	#   @option options [Number]	:radius
	# @overload new(edge_count, options)
	#   Construct a {RegularPolygon} using named center and diameter parameters
	#   @param [Number]	edge_count  The number of edges
	#   @option options [Point]	:center
	#   @option options [Number]	:diameter
	def self.new(edge_count, *args, &block)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)
	    center, radius = args[0..1]

	    raise ArgumentError, "RegularPolygon requires an edge count" unless edge_count

	    center ||= options[:center]
	    center = center ? Point[center] : nil

	    radius ||= options[:radius]

	    if radius
		self.allocate.tap {|circle| circle.send :initialize, edge_count, center, radius, &block }
	    elsif options.has_key?(:diameter)
		DiameterRegularPolygon.new edge_count, center, options[:diameter], &block
	    else
		raise ArgumentError, "RegularPolygon.new requires a radius or a diameter"
	    end
	end

	# Construct a new {RegularPolygon} from a centerpoint and radius
	# @param    [Number]	edge_count  The number of edges
	# @param    [Point]	center  The center point of the {Circle}
	# @param    [Number]	radius  The radius of the {Circle}
	# @return   [RegularPolygon]	A new {RegularPolygon} object
	def initialize(edge_count, center, radius)
	    @center = Point[center]
	    @edge_count = edge_count
	    @radius = radius
	end

	def eql?(other)
	    (self.center == other.center) && (self.edge_count == other.edge_count) && (self.radius == other.radius)
	end
	alias :== :eql?

# @!group Accessors
	# @!attribute [r] diameter
	#   @return [Numeric] The diameter of the {RegularPolygon}
	def diameter
	    @radius*2
	end
# @!endgroup
    end

    class DiameterRegularPolygon < RegularPolygon
	# @return [Number]  The {RegularPolygon}'s diameter
	attr_reader :diameter

	# Construct a new {RegularPolygon} from a centerpoint and a diameter
	# @param    [Number]	edge_count  The number of edges
	# @param    [Point]	center  The center point of the {RegularPolygon}
	# @param    [Number]	diameter  The radius of the {RegularPolygon}
	# @return   [RegularPolygon]	A new {RegularPolygon} object
	def initialize(edge_count, center, diameter)
	    @center = center ? Point[center] : nil
	    @edge_count = edge_count
	    @diameter = diameter
	end

	def eql?(other)
	    (self.center == other.center) && (self.edge_count == other.edge_count) && (self.diameter == other.diameter)
	end
	alias :== :eql?

# @!group Accessors
	# @return The {RegularPolygon}'s radius
	def radius
	    @diameter/2
	end
# @!endgroup
    end
end
