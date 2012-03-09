require 'matrix'

module Geometry
    class Point < Vector
	
	# Custom accessors to enable a more natural notation
	def x
	    @elements[0]
	end
	def y
	    @elements[1]
	end
	def z
	    @elements[2]
	end

	# Allow vector-style initialization, but override to
	#  support copy-init from another Vector or Point
	def self.[](*array)
	    array = array[0] if array[0].is_a?(Array)
	    return Point[*(array[0].to_a)] if array[0].is_a?(Vector)
	    super *array
	end

	def inspect
	    'Point' + @elements.inspect
	end
	def to_s
	    'Point' + @elements.to_s
	end
    end
    
end

def Geometry.Point(*args)
    args[0] = args[0].to_a if args[0].is_a?(Vector)
    args = args[0] if args[0].is_a?(Array)
    Geometry::Point[*args]
end
