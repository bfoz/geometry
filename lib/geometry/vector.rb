require 'matrix'

# Monkeypatch Vector to overcome some deficiencies
class Vector
# @group Unary operators
    def +@
	self
    end

    def -@
	Vector[*(@elements.map {|e| -e })]
    end
# @endgroup
end
