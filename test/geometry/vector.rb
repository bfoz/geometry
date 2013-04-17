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
	
	it "must cross product" do
	    left.cross(right).must_equal -2
	    Vector[1,2,3].cross(Vector[3,4,5]).must_equal Vector[-2, 4, -2]
	    (Vector[1,2,3] ** Vector[3,4,5]).must_equal Vector[-2, 4, -2]
	end

	it "must have a constant representing the X axis" do
	    Vector::X.must_equal Vector[1,0,0]
	end

	it "must have a constant representing the Y axis" do
	    Vector::Y.must_equal Vector[0,1,0]
	end

	it "must have a constant representing the Z axis" do
	    Vector::Z.must_equal Vector[0,0,1]
	end

	it "must not create global axis constants" do
	    -> { X }.must_raise NameError
	    -> { Y }.must_raise NameError
	    -> { Z }.must_raise NameError
	end
    end
end
