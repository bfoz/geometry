require 'geometry/point'

module Geometry
=begin
{Transformation} represents a relationship between two coordinate frames

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
    	# @option options [Point]	:origin	    Same as :translate
    	# @option options [Point]	:move	    Same as :translate
    	# @option options [Point]	:translate  Linear displacement
    	# @option options [Rotation]	:rotate	    Rotation
    	# @option options [Vector]	:scale	    Scaling
	# @option options [Vector]	:x	    X-axis
	# @option options [Vector]	:y	    Y-axis
	# @option options [Vector]	:z	    Z-axis
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    translate, rotate, scale = args
	    options = options.reduce({}, :merge)

	    if options.key?(:rotate) and (options.key?(:x) or options.key?(:y) or options.key?(:z))
		raise ArgumentError, "Can't specify rotation and axes at the same time"
	    end

	    @x_axis = options[:x]
	    @y_axis = options[:y]
	    @z_axis = options[:z]

	    @rotation = options[:rotate] || rotate
	    @scale = options[:scale] || scale

	    case options.count {|k,v| [:move, :origin, :translate].include? k }
		when 0
		    @translation = translate
		when 1
		    @translation = (options[:translate] ||= options.delete(:move) || options.delete(:origin))
		else
		    raise ArgumentError, "Too many translation parameters in #{options}"
	    end

	    @translation = Point[*@translation] if @translation.is_a?(Array)
	    if @translation
		@translation = nil if @translation.all? {|v| v == 0}
		raise ArgumentError, ":translate must be a Point or a Vector" if @translation and not @translation.is_a?(Vector)
	    end
	end

	# Returns true if the {Transformation} is the identity transformation
	def identity?
	    !(@rotation || @scale || @translation)
	end
    end
end
