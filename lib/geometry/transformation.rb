require 'geometry/point'

module Geometry
=begin
{Transformation} represents a relationship between two coordinate frames

To create a pure translation relationship:

    translate = Geometry::Transformation.new(:translate => Point[4, 2])
=end
    class Transformation
    	attr_reader :rotation
    	attr_reader :scale
    	attr_reader :translation

    	# @overload new(translate, rotate, scale)
    	# @param [Point] translate	Linear displacement
    	# @param [Rotation] rotate	Rotation
    	# @param [Vector]   scale	Scaling
    	# @overload new(options)
    	# @param [Hash] options
    	# @option options [Point,Array]		:translate	Linear displacement
    	# @option options [Rotation,Array]	:rotate		Rotation
    	# @option options [Vector,Array]	:scale		Scaling
	def initialize(*args)
	    options, args = args.partition {|a| a.is_a? Hash}
	    translate, rotate, scale = args
	    options = options.reduce({}, :merge)

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

	def identity?
	    !(@rotation || @scale || @translation)
	end
    end
end
