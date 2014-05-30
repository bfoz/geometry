require 'matrix'

require_relative 'cluster_factory'
require_relative 'point'

module Geometry
=begin
A generalized representation of a rotation transformation.

== Usage
    Rotation.new angle:45*Math.PI/180	# Rotate 45 degrees counterclockwise
    Rotation.new x:[0,1]		# Rotate 90 degrees counterclockwise
=end
    class Rotation
	include ClusterFactory

	# @return [Integer] dimensions
	attr_reader :dimensions
	attr_reader :x, :y, :z

	# @overload new(angle)
	#   Create a planar {Rotation} with an angle
	def self.new(*args)
	    options = args.select {|a| a.is_a? Hash}.reduce({}, :merge)

	    if options.has_key? :angle
		RotationAngle.new options[:angle]
	elsif options.has_key?(:x) && [:x, :y, :z].one? {|k| options.has_key? k }
		RotationAngle.new x:options[:x]
	    else
		self.allocate.tap {|rotation| rotation.send :initialize, *args }
	    end
	end

	# @overload initialize(options={})
	# @option options [Radians]	:angle	    Planar rotation angle
	# @option options [Integer]	:dimensions Dimensionality of the rotation
	# @option options [Vector]	:x	    X-axis
	# @option options [Vector]	:y	    Y-axis
	# @option options [Vector]	:z	    Z-axis
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    @dimensions = options[:dimensions] || nil

	    axis_options = [options[:x], options[:y], options[:z]]
	    all_axes_options = [options[:x], options[:y], options[:z]].select {|a| a}
	    if all_axes_options.count != 0
		@x = options[:x] || nil
		@y = options[:y] || nil
		@z = options[:z] || nil

		raise ArgumentError, "All axis options must be Vectors" unless all_axes_options.all? {|a| a.is_a?(Vector) or a.is_a?(Array) }

		raise ArgumentError, "All provided axes must be the same size" unless all_axes_options.all? {|a| a.size == all_axes_options.first.size}

		@dimensions ||= all_axes_options.first.size

		raise ArgumentError, "Dimensionality mismatch" unless all_axes_options.first.size <= @dimensions
		if all_axes_options.first.size < @dimensions
		    @x, @y, @z = [@x, @y, @z].map {|a| (a && (a.size != 0) && (a.size < @dimensions)) ? Array.new(@dimensions) {|i| a[i] || 0 } : a }
		end

		raise ArgumentError, "Too many axes specified (expected #{@dimensions - 1} but got #{all_axes_options.size}" unless all_axes_options.size == (@dimensions - 1)
	    end
	end

	def eql?(other)
	    (self.x.eql? other.x) && (self.y.eql? other.y) && (self.z.eql? other.z)
	end
	alias :== :eql?

	def identity?
	    (!@x && !@y && !@z) || ([@x, @y, @z].select {|a| a}.all? {|a| a.respond_to?(:magnitude) ? (1 == a.magnitude) : (1 == a.size)})
	end

	# @attribute [r] matrix
	# @return [Matrix] the transformation {Matrix} representing the {Rotation}
	def matrix
	    return nil unless [@x, @y, @z].compact.size >= 2

	    # Force all axes to be Vectors
	    x,y,z = [@x, @y, @z].map {|a| a.is_a?(Array) ? Vector[*a] : a}

	    # Force all axes to exist
	    if x and y
		z = x ** y
	    elsif x and z
		y = x ** z
	    elsif y and z
		x = y ** z
	    end

	    rows = []
	    [x, y, z].each_with_index {|a, i| rows.push(a.to_a) if i < @dimensions }

	    raise ArgumentError, "Number of axes must match the dimensions of each axis" unless @dimensions == rows.size

	    Matrix[*rows]
	end


	# Transform and return a new {Point}
	# @param [Point] point	the {Point} to rotate into the parent coordinate frame
	# @return [Point]   the rotated {Point}
	def transform(point)
	    return point if point.is_a?(PointZero)
	    m = matrix
	    m ? Point[m * Point[point]] : point
	end
    end

    class RotationAngle < Rotation
	# @return [Radians] the planar rotation angle
	attr_accessor :angle

	# @option options [Radians] :angle	the rotation angle from the parent coordinate frame
	# @option options [Point]   :x		the X-axis expressed in the parent coordinate frame
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    options = options.reduce({}, :merge)

	    angle = options[:angle] || args[0]

	    if angle
		@angle = angle
	    elsif options.has_key? :x
		@angle = Math.atan2(*options[:x].to_a.reverse)
	    else
		@angle = 0
	    end
	end

	def eql?(other)
	    case other
		when RotationAngle then angle.eql? other.angle
		else
		    false
	    end
	end
	alias :== :eql?

# @group Accessors
	# !@attribute [r] matrix
	#   @return [Matrix] the transformation {Matrix} representing the {Rotation}
	def matrix
	    return nil unless angle

	    c, s = Math.cos(angle), Math.sin(angle)
	    Matrix[[c, -s], [s, c]]
	end

	# !@attribute [r] x
	#   @return [Point] the X-axis expressed in the parent coordinate frame
	def x
	    Point[Math.cos(angle), Math.sin(angle)]
	end

	# !@attribute [r] y
	#   @return [Point] the Y-axis expressed in the parent coordinate frame
	def y
	    Point[-Math.sin(angle), Math.cos(angle)]
	end
# @endgroup

# @group Composition
	def -@
	    RotationAngle.new(-angle)
	end

	def +(other)
	    case other
		when RotationAngle
		    RotationAngle.new(angle + other.angle)
		else
		    raise TypeError, "Can't compose a #{self.class} with a #{other.class}"
	    end
	end

	def -(other)
	    case other
		when RotationAngle
		    RotationAngle.new(angle - other.angle)
		else
		    raise TypeError, "Can't subtract #{other.class} from #{self.class}"
	    end
	end
# @endgroup
    end
end
