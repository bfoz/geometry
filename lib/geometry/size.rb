require 'matrix'

module Geometry
=begin
An object representing the size of something.
 
Supports all of the familiar {Vector} methods as well as a few convenience 
methods (width, height and depth).
 
== Usage
 
=== Constructor
   size = Geometry::Size[x,y,z]
=end

    class Size < Vector
	attr_reader :x, :y, :z
	
	# Allow vector-style initialization, but override to support copy-init
	# from Vector, Point or another Size
	#
	# @overload [](x,y,z,...)
	# @overload [](Point)
	# @overload [](Size)
	# @overload [](Vector)
	# @return [Size]    A new {Size} object
	def self.[](*array)
	    array = array[0].to_a unless array[0].is_a?(Numeric)
	    super *array
	end
	
	# Allow comparison with an Array, otherwise do the normal thing
	def ==(other)
	    return @elements == other if other.is_a?(Array)
	    super other
	end

	def inspect
	    'Size' + @elements.inspect
	end
	def to_s
	    'Size' + @elements.to_s
	end

	# @return [Number]  The size along the Z axis
	def depth
	    z
	end

	# @return [Number]  The size along the Y axis
	def height
	    y
	end

	# @return [Number]  The size along the X axis
	def width
	    x
	end

	# @return [Number] X-component (width)
	def x
	    @elements[0]
	end

	# @return [Number] Y-component (height)
	def y
	    @elements[1]
	end

	# @return [Number] Z-component (depth)
	def z
	    @elements[2]
	end
    end
end
