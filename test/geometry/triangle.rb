require 'minitest/autorun'
require 'geometry/triangle'

describe Geometry::Triangle do
    Triangle = Geometry::Triangle

    it 'must always be closed' do
	Triangle.new([0,0], [0,1], [1,0]).closed?.must_equal true
    end

    describe "when constructed with 3 points" do
	let(:triangle) { Triangle.new [0,0], [0,1], [1,0] }

	it "must create a scalene Triangle" do
	    triangle.must_be_instance_of Geometry::ScaleneTriangle
	    triangle.must_be_kind_of Triangle
	end

	it "must have a points accessor" do
	    triangle.points.must_equal [Point[0,0], Point[0,1], Point[1,0]]
	end

	it 'must know the max' do
	    triangle.max.must_equal Point[1,1]
	end

	it 'must know the min' do
	    triangle.min.must_equal Point[0,0]
	end

	it 'must know the min and the max' do
	    triangle.minmax.must_equal [Point[0,0], Point[1,1]]
	end
    end

    describe "when constructed with a point and a leg length" do
	let(:triangle) { Triangle.new [0,0], 1 }

	it "must create a right Triangle" do
	    triangle.must_be_instance_of Geometry::RightTriangle
	    triangle.must_be_kind_of(Triangle)
	end

	it "must have a points accessor" do
	    triangle.points.must_equal [Point[0,0], Point[0,1], Point[1,0]]
	end
    end
end
