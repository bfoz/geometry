# Include this module in the base class of a class cluster to handle swizzling
# of ::new
module ClusterFactory
    def self.included(parent)
	class << parent
	    alias :original_new :new

	    def inherited(subclass)
		class << subclass
		    alias :new :original_new
		end
	    end
	end
    end
end
