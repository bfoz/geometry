require 'geometry/point'
require 'geometry/rotation'

require_relative 'transformation/composition'

module Geometry
=begin
{Transformation} represents a relationship between two coordinate frames.

To create a pure translation relationship:

    translate = Geometry::Transformation.new(:translate => Point[4, 2])

To create a transformation with an origin and an X-axis aligned with the parent
coordinate system's Y-axis (the Y and Z axes will be chosen arbitrarily):

    translate = Geometry::Transformation.new(:origin => [4, 2], :x => [0,1,0])

To create a transformation with an origin, an X-axis aligned with the parent
coordinate system's Y-axis, and a Y-axis aligned with the parent coordinate
system's X-axis:

    translate = Geometry::Transformation.new(:origin => [4, 2], :x => [0,1,0], :y => [1,0,0])
=end
    class Transformation
	attr_reader :dimensions
    	attr_reader :rotation
    	attr_reader :scale
    	attr_reader :translation

	attr_reader :x_axis, :y_axis, :z_axis

    	# @overload new(translate, rotate, scale)
    	# @param [Point] translate	Linear displacement
    	# @param [Rotation] rotate	Rotation
    	# @param [Vector]   scale	Scaling
    	# @overload new(options)
    	# @param [Hash] options
	# @option options [Integer]	:dimensions Dimensionality of the transformation
    	# @option options [Point]	:origin	    Same as :translate
    	# @option options [Point]	:move	    Same as :translate
    	# @option options [Point]	:translate  Linear displacement
	# @option options [Angle]	:angle	    Rotation angle (assumes planar geometry)
    	# @option options [Rotation]	:rotate	    Rotation
    	# @option options [Vector]	:scale	    Scaling
	# @option options [Vector]	:x	    X-axis
	# @option options [Vector]	:y	    Y-axis
	# @option options [Vector]	:z	    Z-axis
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    translate, rotate, scale = args
	    options = options.reduce({}, :merge)

	    @dimensions = options[:dimensions] || nil

	    rotation_options = options.select {|key, value| [:angle, :x, :y, :z].include? key }
	    @rotation = options[:rotate] || rotate || ((rotation_options.size > 0) ? Geometry::Rotation.new(rotation_options) : nil)
	    @scale = options[:scale] || scale

	    case options.count {|k,v| [:move, :origin, :translate].include? k }
		when 0
		    @translation = translate
		when 1
		    @translation = (options[:translate] ||= options.delete(:move) || options.delete(:origin))
		else
		    raise ArgumentError, "Too many translation parameters in #{options}"
	    end

	    raise ArgumentError, "Bad translation" if @translation.is_a? Hash
	    @translation = Point[*@translation]
	    if @translation
		@translation = nil if @translation.all? {|v| v == 0}
		raise ArgumentError, ":translate must be a Point or a Vector" if @translation and not @translation.is_a?(Vector)
	    end

	    if @dimensions
		biggest = [@translation, @scale].select {|a| a}.map {|a| a.size}.max

		if biggest and (biggest != 0) and (((biggest != @dimensions)) or (@rotation and (@rotation.dimensions != biggest)))
		    raise ArgumentError, "Dimensionality mismatch"
		end
	    end
	end

	def initialize_clone(source)
	    super
	    @rotation = @rotation.clone if @rotation
	    @scale = @scale.clone if @scale
	    @translation = @translation.clone if @translation
	end

	# !@attribute [r] has_rotation?
	#   @return [Bool] true if the transformation has any rotation components
	def has_rotation?
	    !!@rotation
	end

	# Returns true if the {Transformation} is the identity transformation
	def identity?
	    !(@rotation || @scale || @translation)
	end

	def eql?(other)
	    return false unless other
	    return true if !self.dimensions && !other.dimensions && !self.rotation && !other.rotation && !self.translation && !other.translation && !self.scale && !other.scale
	    return false if !(self.dimensions && other.dimensions) && !(self.rotation && other.rotation) && !(self.translation && other.translation) && !(self.scale && other.scale)

	    ((self.dimensions && other.dimensions && self.dimensions.eql?(other.dimensions)) || !(self.dimensions && other.dimensions)) &&
	    ((self.rotation && other.rotation && self.rotation.eql?(other.rotation)) || !(self.rotation && other.rotation)) &&
	    ((self.scale && other.scale && self.scale.eql?(other.scale)) || !(self.scale && other.rotation)) &&
	    ((self.translation && other.translation && self.translation.eql?(other.translation)) || !(self.scale && other.rotation))
	end
	alias :== :eql?

	# Update the translation property with the given {Point}
	# @param point [Point]	the distance to translate by
	# @return [Transformation]
	def translate(point)
	    if translation
		@translation += Point[point]
	    else
		@translation = Point[point]
	    end
	    self
	end

	# Compose the current {Transformation} with another one
	def +(other)
	    return self.clone unless other

	    case other
		when Array, Vector
		    if @translation
			Transformation.new(@translation+other, @rotation, @scale)
		    else
			Transformation.new(other, @rotation, @scale)
		    end
		when Composition
		    Composition.new(self, *other.transformations)
		when Transformation
		    if @rotation || other.rotation
			Composition.new(self, other)
		    else
			translation = @translation ? (@translation + other.translation) : other.translation
			Transformation.new(translation, @rotation, @scale)
		    end
	    end
	end

	def -(other)
	    return self.clone unless other

	    case other
		when Array, Vector
		    if @translation
			Transformation.new(@translation-other, @rotation, @scale)
		    else
			Transformation.new(other.map {|e| -e}, @rotation, @scale)
		    end
		when Transformation
		    if @rotation
			rotation = other.rotation ? (@rotation - other.rotation) : @rotation
		    elsif other.rotation
			rotation = -other.rotation
		    else
			rotation = nil
		    end

		    translation = @translation ? (@translation - other.translation) : -other.translation

		    Transformation.new(translation, rotation, @scale)
	    end
	end

	# Transform and return a new {Point}. Rotation is applied before translation.
	# @param [Point] point	the {Point} to transform into the parent coordinate frame
	# @return [Point]   The transformed {Point}
	def transform(point)
	    point = @rotation.transform(point) if @rotation
	    @translation ? (@translation + point) : point
	end
    end

    # @override translation(x, y, z)
    #   Construct a new translation from the given values
    #   @param x    [Number]	The distance to translate along the X-axis
    #   @param y    [Number]	The distance to translate along the Y-axis
    #   @param z    [Number]	The distance to translate along the Z-axis
    # @override translation([x, y, z])
    #   Construct a new translation from an array of values
    # @override translation(point)
    #   Construct a new translation from a {Point}
    #   @param point	[Point]	A {Point}
    def self.translation(*args)
	args = *args if args[0].is_a? Array
	Transformation.new translate:args
    end
end
