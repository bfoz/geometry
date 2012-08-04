require 'minitest/autorun'
require 'geometry/vector'

describe Vector do
    describe "when monkeypatching Vector" do
	let(:left) { Vector[1,2] }
	let(:right) { Vector[3,4] }
	
	it "must have +@" do
	    (+left).must_equal Vector[1,2]
	end
	
	it "must have unary negation" do
	    (-left).must_equal Vector[-1,-2]
	end
    end
end
