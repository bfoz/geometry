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

	it "must compare equal" do
	    circle.must_equal Circle.new([1,2], 3)
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

	it "must compare equal" do
	    (circle == Circle.new(:center => [1,2], :radius => 3)).must_equal true
	end
    end

    describe "when constructed with named center and diameter arguments" do
	let(:circle) { Circle.new center:[1,2], diameter:4 }

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

	it "must compare equal" do
	    circle.must_equal Circle.new([1,2], :diameter => 4)
	end
    end

    describe "when constructed with a diameter and no center" do
	let(:circle) { Circle.new :diameter => 4 }

	it "must be a CenterDiameterCircle" do
	    circle.must_be_instance_of(Geometry::CenterDiameterCircle)
	    circle.must_be_kind_of(Circle)
	end

	it "must have a nil center" do
	    circle.center.must_be_kind_of Geometry::PointZero
	end

	it "must have a diameter" do
	    circle.diameter.must_equal 4
	end

	it "must calculate the correct radius" do
	    circle.radius.must_equal 2
	end

	it 'must have the correct min values' do
	    circle.min.must_equal Point[-2, -2]
	    circle.min.must_be_instance_of Geometry::PointIso
	end

	it 'must have the correct max values' do
	    circle.max.must_equal Point[2, 2]
	    circle.max.must_be_instance_of Geometry::PointIso
	end

	it 'must have the correct minmax values' do
	    circle.minmax.must_equal [Point[-2, -2], Point[2,2]]
	end
    end

    describe 'when constructed with a Rational diameter and no center' do
	let(:circle) { Circle.new :diameter => Rational(5,3) }

	it 'must have the correct min values' do
	    circle.min.must_equal Point[-5/6, -5/6]
	    circle.min.must_be_instance_of Geometry::PointIso
	end

	it 'must have the correct max values' do
	    circle.max.must_equal Point[5/6, 5/6]
	    circle.max.must_be_instance_of Geometry::PointIso
	end

	it 'must have the correct minmax values' do
	    circle.minmax.must_equal [Point[-5/6, -5/6], Point[5/6,5/6]]
	end
    end

    describe "properties" do
	subject { Circle.new center:[1,2], :diameter => 4 }

	it "must have a bounds property that returns a Rectangle" do
	    subject.bounds.must_equal Rectangle.new([-1,0], [3,4])
	end

	it 'must always be closed' do
	    subject.closed?.must_equal true
	end

	it "must have a minmax property that returns the corners of the bounding rectangle" do
	    subject.minmax.must_equal [Point[-1,0], Point[3,4]]
	end

	it "must have a max property that returns the upper right corner of the bounding rectangle" do
	    subject.max.must_equal Point[3,4]
	end

	it "must have a min property that returns the lower left corner of the bounding rectangle" do
	    subject.min.must_equal Point[-1,0]
	end
    end
end
