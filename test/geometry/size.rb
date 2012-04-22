require_relative '../helper'
require_relative '../../lib/geometry/size'

class SizeTest < Test::Unit::TestCase
    Size = Geometry::Size

    must "create a Size object using list syntax" do
	size = Geometry::Size[2,1]
	assert_equal(2, size.size)
	assert_equal(2, size.x)
	assert_equal(1, size.y)
    end

    must "create a Size object from an array" do
	size = Geometry::Size[[3,4]]
	assert_equal(2, size.size)
	assert_equal(3, size.x)
	assert_equal(4, size.y)
    end

    must "create a Size object from individual parameters" do
	size = Geometry::Size[3,4]
	assert_equal(2, size.size)
	assert_equal(3, size.x)
	assert_equal(4, size.y)
    end

    must "create a Size object from a Size" do
	size = Geometry::Size[Geometry::Size[3,4]]
	assert_equal(2, size.size)
	assert_equal(3, size.x)
	assert_equal(4, size.y)
    end

    must "create a Size object from a Vector" do
	size = Geometry::Size[Vector[3,4]]
	assert_equal(2, size.size)
	assert_equal(3, size.x)
	assert_equal(4, size.y)
    end

    must "allow indexed element access" do
	size = Geometry::Size[5,6]
	assert_equal(2, size.size)
	assert_equal(5, size[0])
	assert_equal(6, size[1])
    end
    must "allow named element access" do
	size = Geometry::Size[5,6,7]
	assert_equal(3, size.size)
	assert_equal(5, size.x)
	assert_equal(6, size.y)
	assert_equal(7, size.z)
    end

    must "have a width accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(5, size.width)
    end

    must "have a height accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(6, size.height)
    end

    must "have a depth accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(7, size.depth)
    end

    must "compare equal" do
	size1 = Geometry::Size[1,2]
	size2 = Geometry::Size[1,2]
	size3 = Geometry::Size[3,4]
	assert_equal(size1, size2)
	assert_not_equal(size2, size3)
    end

    must "compare equal to an array with equal elements" do
	size1 = Size[1,2]
	assert_equal(size1, [1,2])
    end

    must "not compare equal to an array with unequal elements" do
	size1 = Size[1,2]
	assert_not_equal(size1, [3,2])
    end

    must "implement inspect" do
	size = Geometry::Size[8,9]
	assert_equal('Size[8, 9]', size.inspect)
    end
    must "implement to_s" do
	size = Geometry::Size[10,11]
	assert_equal('Size[10, 11]', size.to_s)
    end
end
