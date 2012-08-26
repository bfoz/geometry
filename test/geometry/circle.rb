require 'minitest/autorun'
require 'geometry/circle'

describe Geometry::Circle do
    Circle = Geometry::Circle

    describe "when constructed with center and radius arguments" do
	let(:circle) { Circle.new [1,2], 3 }

	it "must create a Circle" do
	    circle.must_be_instance_of(Circle)
	end
	
	it "must have a center point accessor" do
	    circle.center.must_equal Point[1,2]
	end
	
	it "must have a radius accessor" do
	    circle.radius.must_equal 3
	end
    end

    describe "when constructed with named center and radius arguments" do
	let(:circle) { Circle.new :center => [1,2], :radius => 3 }
	
	it "must create a Circle" do
	    circle.must_be_instance_of(Circle)
	end
	
	it "must have a center point accessor" do
	    circle.center.must_equal Point[1,2]
	end
	
	it "must have a radius accessor" do
	    circle.radius.must_equal 3
	end
    end

    describe "when constructed with a center and diameter" do
	let(:circle) { Circle.new [1,2], :diameter => 4 }

	it "must be a CenterDiameterCircle" do
	    circle.must_be_instance_of(Geometry::CenterDiameterCircle)
	    circle.must_be_kind_of(Circle)
	end

	it "must have a center" do
	    circle.center.must_equal Point[1,2]
	end

	it "must have a diameter" do
	    circle.diameter.must_equal 4
	end

	it "must calculate the correct radius" do
	    circle.radius.must_equal 2
	end
    end
end
