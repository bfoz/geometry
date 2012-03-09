require 'matrix'

module Geometry
    class Point < Vector
	# An object repesenting a Point in N-dimensional space
	#
	# Supports all of the familiar Vector methods and adds convenience
	# accessors for those variables you learned to hate in your high school
	# geometry class (x, y, z).
	#
	# *Usage*
	#
	# point = Geometry::Point[x,y]

	# :call-seq:
	#   Point[x,y,z,...]
	#   Point[Point]
	#   Point[Vector]
	#
	# Allow vector-style initialization, but override to support copy-init
	# from Vector or another Point
	def self.[](*array)
	    array = array[0] if array[0].is_a?(Array)
	    return Point[*(array[0].to_a)] if array[0].is_a?(Vector)
	    super *array
	end

	def inspect # :nodoc:
	    'Point' + @elements.inspect
	end
	def to_s    # :nodoc:
	    'Point' + @elements.to_s
	end
    
	def x
	    @elements[0]
	end
	def y
	    @elements[1]
	end
	def z
	    @elements[2]
	end
    end
end

def Geometry.Point(*args)
    args[0] = args[0].to_a if args[0].is_a?(Vector)
    args = args[0] if args[0].is_a?(Array)
    Geometry::Point[*args]
end
