require 'minitest/autorun'
require 'geometry/size'

describe Geometry::Size do
    describe "when constructed" do
	it "create a Size object using list syntax" do
	    size = Geometry::Size[2,1]
	    assert_equal(2, size.size)
	    assert_equal(2, size.x)
	    assert_equal(1, size.y)
	end

	it "create a Size object from an array" do
	    size = Geometry::Size[[3,4]]
	    assert_equal(2, size.size)
	    assert_equal(3, size.x)
	    assert_equal(4, size.y)
	end

	it "create a Size object from individual parameters" do
	    size = Geometry::Size[3,4]
	    assert_equal(2, size.size)
	    assert_equal(3, size.x)
	    assert_equal(4, size.y)
	end

	it "create a Size object from a Size" do
	    size = Geometry::Size[Geometry::Size[3,4]]
	    assert_equal(2, size.size)
	    assert_equal(3, size.x)
	    assert_equal(4, size.y)
	end

	it "create a Size object from a Vector" do
	    size = Geometry::Size[Vector[3,4]]
	    assert_equal(2, size.size)
	    assert_equal(3, size.x)
	    assert_equal(4, size.y)
	end
    end

    it "allow indexed element access" do
	size = Geometry::Size[5,6]
	assert_equal(2, size.size)
	assert_equal(5, size[0])
	assert_equal(6, size[1])
    end
    it "allow named element access" do
	size = Geometry::Size[5,6,7]
	assert_equal(3, size.size)
	assert_equal(5, size.x)
	assert_equal(6, size.y)
	assert_equal(7, size.z)
    end

    it "have a width accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(5, size.width)
    end

    it "have a height accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(6, size.height)
    end

    it "have a depth accessor" do
	size = Geometry::Size[5,6,7]
	assert_equal(7, size.depth)
    end

    it "compare equal" do
	size1 = Geometry::Size[1,2]
	size2 = Geometry::Size[1,2]
	size3 = Geometry::Size[3,4]
	assert_equal(size1, size2)
	size2.wont_equal size3
    end

    it "compare equal to an array with equal elements" do
	size1 = Size[1,2]
	assert_equal(size1, [1,2])
    end

    it "not compare equal to an array with unequal elements" do
	size1 = Size[1,2]
	size1.wont_equal [3,2]
    end

    it "implement inspect" do
	size = Geometry::Size[8,9]
	assert_equal('Size[8, 9]', size.inspect)
    end
    it "implement to_s" do
	size = Geometry::Size[10,11]
	assert_equal('Size[10, 11]', size.to_s)
    end
end
