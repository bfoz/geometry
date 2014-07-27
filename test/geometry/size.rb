require 'minitest/autorun'
require 'geometry/size'

describe Geometry::Size do
    subject { Geometry::Size[10,10] }

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

    describe 'when array access' do
	it 'must allow indexed access' do
	    size = Geometry::Size[5,6]
	    size.size.must_equal 2
	    size[0].must_equal 5
	    size[1].must_equal 6
	end

	it 'must slize with a start index and a length' do
	    size = Geometry::Size[5, 6, 7]
	    slice = size[1,2]
	    slice.length.must_equal 2
	end
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

    it 'must inset with horizontal and vertical insets' do
	subject.inset(4).must_equal Geometry::Size[6, 6]
	subject.inset(2,3).must_equal Geometry::Size[6, 4]
	subject.inset(x:2, y:3).must_equal Geometry::Size[6, 4]
    end

    it 'must inset with left and top' do
	subject.inset(left:2, top:3).must_equal Geometry::Size[8, 7]
    end

    it 'must inset with right and bottom' do
	subject.inset(right:2, bottom:3).must_equal Geometry::Size[8, 7]
    end

    it 'must inset with insets for top, left, bottom, right' do
	subject.inset(top:1, left:2, bottom:3, right:4).must_equal Geometry::Size[4, 6]
    end

    it 'must outset' do
	subject.outset(4).must_equal Geometry::Size[14, 14]
	subject.outset(2,3).must_equal Geometry::Size[14, 16]
	subject.outset(x:2, y:3).must_equal Geometry::Size[14, 16]
    end

    it 'must outset with left and top' do
	subject.outset(left:2, top:3).must_equal Geometry::Size[12, 13]
    end

    it 'must outset with right and bottom' do
	subject.outset(right:2, bottom:3).must_equal Geometry::Size[12, 13]
    end

    it 'must outset with insets for top, left, bottom, right' do
	subject.outset(top:1, left:2, bottom:3, right:4).must_equal Geometry::Size[16, 14]
    end
end
