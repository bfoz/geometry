require 'matrix'

# Monkeypatch Vector to overcome some deficiencies
class Vector
    X = Vector[1,0,0]
    Y = Vector[0,1,0]
    Z = Vector[0,0,1]

# @group Unary operators
    def +@
	self
    end

    def -@
	Vector[*(@elements.map {|e| -e })]
    end
# @endgroup

    # Cross-product of two {Vector}s
    # @return [Vector]
    def cross(other)
	Vector.Raise ErrDimensionMismatch unless @elements.size == other.size
	
	case @elements.size
	    when 0 then raise ArgumentError, "Can't multply zero-length Vectors"
	    when 1 then @elements.first * other.first
	    when 2 then @elements.first * other[1] - @elements.last * other.first
	    when 3 then Vector[ @elements[1]*other[2] - @elements[2]*other[1],
				@elements[2]*other[0] - @elements[0]*other[2],
				@elements[0]*other[1] - @elements[1]*other[0]]
	end
    end
    alias ** cross
end
