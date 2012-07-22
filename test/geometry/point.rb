require 'minitest/autorun'
require 'geometry/point'

#Point = Geometry::Point

describe Geometry::Point do
    it "create a Point object using list syntax" do
	point = Geometry::Point[2,1]
	assert_equal(2, point.size)
	assert_equal(2, point.x)
	assert_equal(1, point.y)
    end
    it "create a Point object from an array" do
	point = Geometry::Point[[3,4]]
	assert_equal(2, point.size)
	assert_equal(3, point.x)
	assert_equal(4, point.y)
    end
    it "create a Point object from individual parameters" do
	point = Geometry::Point[3,4]
	assert_equal(2, point.size)
	assert_equal(3, point.x)
	assert_equal(4, point.y)
    end
    it "create a Point object from a Vector" do
	point = Geometry::Point[Vector[3,4]]
	assert_equal(2, point.size)
	assert_equal(3, point.x)
	assert_equal(4, point.y)
    end
    it "create a Point object from a Point" do
	point = Geometry::Point[Geometry::Point[3,4]]
	assert_equal(2, point.size)
	assert_equal(3, point.x)
	assert_equal(4, point.y)
    end
    it "create a Point object from a Vector using list syntax" do
	point = Geometry::Point[Vector[3,4]]
	assert_equal(2, point.size)
	assert_equal(3, point.x)
	assert_equal(4, point.y)
    end
    it "create a Point object from a Point using list syntax" do
	point = Geometry::Point[Geometry::Point[13,14]]
	assert_equal(2, point.size)
	assert_equal(13, point.x)
	assert_equal(14, point.y)
    end
    it "allow indexed element access" do
	point = Geometry::Point[5,6]
	assert_equal(2, point.size)
	assert_equal(5, point[0])
	assert_equal(6, point[1])
    end
    it "allow named element access" do
	point = Geometry::Point[5,6,7]
	assert_equal(3, point.size)
	assert_equal(5, point.x)
	assert_equal(6, point.y)
	assert_equal(7, point.z)
    end
    it "compare equal" do
	point1 = Geometry::Point[1,2]
	point2 = Geometry::Point[1,2]
	point3 = Geometry::Point[3,4]
	assert_equal(point1, point2)
	point2.wont_equal point3
    end

    it "compare equal to an array with equal elements" do
	point1 = Point[1,2]
	assert_equal(point1, [1,2])
    end

    it "not compare equal to an array with unequal elements" do
	Point[1,2].wont_equal [3,2]
    end

    it "implement inspect" do
	point = Geometry::Point[8,9]
	assert_equal('Point[8, 9]', point.inspect)
    end
    it "implement to_s" do
	point = Geometry::Point[10,11]
	assert_equal('Point[10, 11]', point.to_s)
    end

    it "must support array access" do
	Point[1,2][0].must_equal 1
	Point[1,2][1].must_equal 2
	Point[1,2][2].must_equal nil
    end

    describe "arithmetic" do
	let(:left) { Point[1,2] }
	let(:right) { Point[3,4] }

	it "return a Point when adding two Points" do
	    assert_kind_of(Point, left+right)
	end

	it "return a Point when subtracting two Points" do
	    assert_kind_of(Point, left-right)
	end
    end
end
