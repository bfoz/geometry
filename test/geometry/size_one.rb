require 'minitest/autorun'
require 'geometry/size_one'

describe Geometry::SizeOne do
    Size = Geometry::Size

    let(:one) { Geometry::SizeOne.new }

    describe 'arithmetic' do
	let(:left) { Size[1,2] }
	let(:right) { Size[3,4] }

	it 'must have +@' do
	    (+one).must_be :eql?, 1
	    (+one).must_be_instance_of(Geometry::SizeOne)
	end

	it 'must have unary negation' do
	    (-one).must_be :eql?, -1
#	    (-one).must_be_instance_of(Geometry::SizeOne)
	end

	it 'must add a number' do
	    (one + 3).must_equal 4
	    (3 + one).must_equal 4
	end

	it 'return a Size when adding two Sizes' do
	    (one + right).must_be_kind_of Size
	    (left + one).must_be_kind_of Size
	end

	it 'must return a Size when adding an array' do
	    (one + [5,6]).must_equal [6,7]
#	    ([5,6] + one).must_equal [6,7]
	end

	describe 'when subtracting' do
	    it 'must subtract a number' do
		(one - 3).must_equal -2
		(3 - one).must_equal 2
	    end

	    it 'return a Size when subtracting two Size' do
		(one - right).must_equal Size[-2,-3]
		(left - one).must_equal Size[0,1]
	    end

	    it 'must return a Size when subtracting an array' do
		(one - [5,6]).must_equal [-4, -5]
#		([5,6] - one).must_equal [6,7]
	    end
	end

	it 'must multiply by a scalar' do
	    (one * 3).must_equal 3
	    (one * 3.0).must_equal 3.0
	end

	it 'must refuse to multiply by a Size' do
	    -> { one * Size[1,2] }.must_raise Geometry::OperationNotDefined
	end

	it 'must refuse to multiply by a Vector' do
	    -> { one * Vector[1, 2] }.must_raise Geometry::OperationNotDefined
	end

	describe 'division' do
	    it 'must divide by a scalar' do
		(one / 3).must_equal 1/3
		(one / 4.0).must_equal 1/4.0
	    end

	    it 'must raise an exception when divided by 0' do
		-> { one / 0 }.must_raise ZeroDivisionError
	    end

	    it 'must raise an exception for Sizes' do
		-> { one / Size[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	    it 'must raise an exception for Vectors' do
		-> { one / Vector[1,2] }.must_raise Geometry::OperationNotDefined
	    end
	end
    end

    describe 'coercion' do
	it 'must coerce Arrays into Sizes' do
	    one.coerce([3,4]).must_equal [Size[3,4], Size[1,1]]
	end

	it 'must coerce Vectors into Vectors' do
	    one.coerce(Vector[3,4]).must_equal [Vector[3,4], Vector[1,1]]
	end

	it 'must coerce Size into Size' do
	    one.coerce(Size[5,6]).must_equal [Size[5,6], Size[1,1]]
	end
    end

    describe 'comparison' do
	let(:one) { Geometry::SizeOne.new }

	it 'must be equal to 1 and 1.0' do
	    one.must_be :eql?, 1
	    one.must_be :eql?, 1.0
	end

	it 'must not be equal to a non-one number' do
	    0.wont_equal one
	    3.14.wont_equal one
	end

	it 'must be equal to an Array of ones' do
	    one.must_be :==, [1,1]
	    one.must_be :eql?, [1,1]
	    [1,1].must_equal one
	end

	it 'must not be equal to a non-one Array' do
	    one.wont_equal [3,2]
	    [3,2].wont_equal one
	end

	it 'must be equal to a Size of ones' do
	    one.must_be :==, Size[1,1]
	    one.must_be :eql?, Size[1,1]
	    Size[1,1].must_equal one
	end

	it 'must not be equal to a non-one Size' do
	    one.wont_equal Size[3,2]
	    Size[3,2].wont_equal one
	end

	it 'must be equal to an Vector of onees' do
	    one.must_be :eql?, Vector[1,1]
	    Vector[1,1].must_equal one
	end

	it 'must not be equal to a non-one Vector' do
	    one.wont_equal Vector[3,2]
	    Vector[3,2].wont_equal one
	end
    end

    describe 'when enumerating' do
	it 'must have a first method' do
	    one.first.must_equal 1
	    one.first(1).must_equal [1]
	    one.first(5).must_equal [1,1,1,1,1]
	end
    end
end
