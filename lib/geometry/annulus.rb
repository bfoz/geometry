module Geometry

=begin rdoc
An {http://en.wikipedia.org/wiki/Annulus_(mathematics) Annulus}, more commonly 
known as a Ring, is a circle that ate another circle.

== Usage
    ring = Geometry::Annulus.new center:[1,2], inner_radius:5, radius:10
    ring = Geometry::Ring.new center:[1,2], inner_radius:5, radius:10
=end
    class Annulus
	# @!attribute center
	#   @return [Point]  The center point of the {Annulus}
	attr_accessor :center

	# @!attribute inner_diameter
	#   @return [Number]  the diameter of the inside of the {Annulus}
	def inner_diameter
	    @inner_diameter || (@inner_radius && 2*@inner_radius)
	end

	# @!attribute inner_radius
	#   @return [Number]  the radius of the inside of the {Annulus}
	def inner_radius
	    @inner_radius || (@inner_diameter && @inner_diameter/2)
	end

	# @!attribute outer_diameter
	#   @return [Number]  the out diameter
	def outer_diameter
	    @outer_diameter || (@outer_radius && 2*@outer_radius)
	end

	# @!attribute outer_radius
	#   @return [Number]  the outer radius
	def outer_radius
	    @outer_radius || (@outer_diameter && @outer_diameter/2)
	end

	# @!attribute diameter
	#   @return [Number]  the outer diameter
	alias :diameter :outer_diameter

	# @!attribute radius
	#   @return [Number]  the outer radius
	alias :radius :outer_radius

	# @note
	#  The 'center' argument can also be passed as a named argument of the same name
	# @overload initialize(center, :inner_radius, :outer_radius)
	#   @param center	 [Point]    The center {Point}, defaults to the origin
	#   @param :inner_radius [Number]   The radius of the hole that's in the center
	#   @param :outer_radius [Number]   The overall radius of the whole thing
	# @overload initialize(center, :inner_diameter, :outer_diameter)
	#   @param center	    [Point]	The center {Point}, defaults to the origin
	#   @param :inner_diameter  [Number]	The radius of the hole that's in the center
	#   @param :outer_diameter  [Number]	The overall radius of the whole thing
	def initialize(center = Point.zero, **options)
	    @center = Point[options.fetch(:center, center)]

	    options.delete :center
	    raise ArgumentError, 'Annulus requires more than a center' if options.empty?

	    @inner_diameter = options[:inner_diameter]
	    @inner_radius = options[:inner_radius]
	    @outer_diameter = options[:outer_diameter] || options[:diameter]
	    @outer_radius = options[:outer_radius] || options[:radius]
	end

	# @!attribute	max
	# @return [Point]   The upper right corner of the bounding {Rectangle}
	def max
	    @center+radius
	end

	# @!attribute	min
	# @return [Point]   The lower left corner of the bounding {Rectangle}
	def min
	    @center-radius
	end

	# @!attribute	minmax
	# @return [Array<Point>]    The lower left and upper right corners of the bounding {Rectangle}
	def minmax
	    [self.min, self.max]
	end
    end

    # Ring is an alias of Annulus because that's the word that most people use,
    #  despite the proclivities of mathmeticians.
    Ring = Annulus
end
