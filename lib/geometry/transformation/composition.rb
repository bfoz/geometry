module Geometry
    class Transformation
	class Composition
	    attr_reader :transformations

	    def initialize(*args)
		raise TypeError unless args.all? {|a| a.is_a? Transformation }
		@transformations = *args
	    end

	    def +(other)
		case other
		    when Transformation
			Composition.new(*transformations, other)
		    when Composition
			Composition.new(*transformations, *other.transformations)
		end
	    end

# @group Accessors
	    # !@attribute [r] size
	    #   @return [Number] the number of composed {Transformation}s
	    def size
		transformations.size
	    end
# @endgroup

	    def transform(point)
		transformations.reverse.reduce(point) {|point, transformation| transformation.transform(point) }
	    end
	end
    end
end