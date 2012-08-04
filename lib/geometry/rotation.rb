module Geometry
=begin
A generalized representation of a rotation transformation.
=end
    class Rotation
	# !@attribute [r] dimensions
	# @return [Integer]
	attr_reader :dimensions
	attr_reader :x, :y, :z

	# @overload initialize(options={})
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
		    @x, @y, @z = [@x, @y, @z].map {|a| (a && (a.size < @dimensions)) ? Array.new(@dimensions) {|i| a[i] || 0 } : a }
		end
	    end
	end

	def identity?
	    (!@x && !@y && !@z) || ([@x, @y, @z].select {|a| a}.all? {|a| a.respond_to?(:magnitude) ? (1 == a.magnitude) : (1 == a.size)})
	end
    end
end
