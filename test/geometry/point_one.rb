require 'minitest/autorun'
require 'geometry/point_one'

describe Geometry::PointOne do
    subject { Geometry::PointOne.new }
    let(:one) { Geometry::PointOne.new }

    it 'must pop' do
	subject.pop.must_equal Point[1]
	subject.pop(2).must_equal Point[1, 1]
    end

    it 'must shift' do
	subject.shift.must_equal Point[1]
	subject.shift(2).must_equal Point[1, 1]
    end

    describe 'minmax' do
	it 'must have a minimum' do
	    subject.min.must_equal 1
	end

	it 'must minimum with another Point' do
	    subject.min(Point[0,7]).must_equal Point[0,1]
	    subject.min(Point[0,7]).must_be_kind_of Point
	end

	it 'must minimum with an Array' do
	    subject.min([0,7]).must_equal Point[0,1]
	end

	it 'must minimum with a multiple arguments' do
	    subject.min(0,7).must_equal Point[0,1]
	end

	it 'must have a maximum' do
	    subject.max.must_equal 1
	end

	it 'must maximum with another Point' do
	    subject.max(Point[7,0]).must_equal Point[7,1]
	    subject.max(Point[7,0]).must_be_kind_of Point
	end

	it 'must maximum with an Array' do
	    subject.max([7,0]).must_equal Point[7,1]
	end

	it 'must maximum with multiple arguments' do
	    subject.max(7,0).must_equal Point[7,1]
	end

	it 'must have a minmax' do
	    subject.minmax.must_equal [1,1]
	end

	it 'must minmax with another Point' do
	    subject.minmax(Point[7,0]).must_equal [Point[1,0], Point[7,1]]
	end

	it 'must minmax with an Array' do
	    subject.minmax([7,0]).must_equal [Point[1,0], Point[7,1]]
	end

	it 'must maximum with multiple arguments' do
	    subject.minmax(7,0).must_equal [Point[1,0], Point[7,1]]
	end
    end

    describe 'arithmetic' do
	let(:left) { Point[1,2] }
	let(:right) { Point[3,4] }

	it 'must pretend to be a Point' do
	    subject.is_a?(Point).must_equal true
	    subject.kind_of?(Point).must_equal true

	    subject.is_a?(Geometry::PointOne).must_equal true
	    subject.kind_of?(Geometry::PointOne).must_equal true

	    subject.instance_of?(Point).must_equal false
	    subject.instance_of?(Geometry::PointOne).must_equal true
	end

	it 'must have +@' do
	    (+one).must_be :eql?, 1
	    (+one).must_be_instance_of(Geometry::PointOne)
	end

	it 'must have unary negation' do
	    (-one).must_be :eql?, -1
#	    (-one).must_be_instance_of(Geometry::PointOne)
	end

	describe 'Accessors' do
	    it 'must return 1 for array access' do
		one[3].must_equal 1
	    end

	    it 'must return 1 for named element access' do
		one.x.must_equal 1
		one.y.must_equal 1
		one.z.must_equal 1
	    end
	end

	it 'must add a number' do
	    (one + 3).must_equal 4
	    (3 + one).must_equal 4
	end

	it 'return a Point when adding two Points' do
	    (one + right).must_be_kind_of Point
	    (left + one).must_be_kind_of Point
	end

	it 'must return an Array when adding an array' do
	    (one + [5,6]).must_equal [6, 7]
	    ([5,6] + one).must_equal [5,6]
	end

	it 'must return a Point when adding a Size' do
	    (one + Size[5,6]).must_be_instance_of(Point)
	    (one + Size[5,6]).must_equal Point[6,7]
	end

	describe 'when subtracting' do
	    it 'must subtract a number' do
		(one - 3).must_equal -2
		(3 - one).must_equal 2
	    end

	    it 'return a Point when subtracting two Points' do
		(one - right).must_equal Point[-2, -3]
		(left - one).must_equal Point[0, 1]
	    end

	    it 'must return a Point when subtracting an array' do
		(one - [5,6]).must_equal [-4, -5]
#		([5,6] - one).must_equal [4,5]
	    end

	    it 'must return a Point when subtracting a Size' do
		(one - Size[5,6]).must_be_instance_of(Point)
		(one - Size[5,6]).must_equal Point[-4,-5]
	    end
	end

	it 'must multiply by a scalar' do
	    (one * 3).must_equal 3
	    (one * 3.0).must_equal 3.0
	end

	it 'must refuse to multiply by a Point' do
	    -> { one * Point[1, 2] }.must_raise Geometry::OperationNotDefined
	end

	it 'must refuse to multiply by a Vector' do
	    -> { one * Vector[2, 3] }.must_raise Geometry::OperationNotDefined
	end

	it 'must divide by a scalar' do
	    (one / 3).must_equal 1/3
	    (one / 4.0).must_equal 1/4.0
	end

	it 'must raise an exception when divided by 0' do
	    -> { one / 0 }.must_raise ZeroDivisionError
	end

	describe 'division' do
	    it 'must raise an exception for Points' do
		lambda { one / Point[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	    it 'must raise an exception for Vectors' do
		lambda { one / Vector[1,2] }.must_raise Geometry::OperationNotDefined
	    end
	end
    end

    describe 'coercion' do
	it 'must coerce Arrays into Points' do
	    one.coerce([3,4]).must_equal [Point[3,4], Point[1, 1]]
	end

	it 'must coerce Vectors into Vectors' do
	    one.coerce(Vector[3,4]).must_equal [Vector[3,4], Vector[1, 1]]
	end

	it 'must coerce Points into Points' do
	    one.coerce(Point[5,6]).must_equal [Point[5,6], Point[1, 1]]
	end
    end

    describe 'comparison' do
	subject { Geometry::PointOne.new }

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
	    one.must_be :===, [1,1]
	    [1, 1].must_equal one
	    one.must_equal [1, 1]
	end

	it 'must not be equal to a non-one Array' do
	    one.wont_equal [3, 2, 1]
	    [3, 2, 1].wont_equal one
	end

	it 'must not be equal to a Point at the origin' do
	    one.wont_be :==, Point[0,0]
	    one.wont_be :eql?, Point[0,0]
	    one.wont_be :===, Point[0,0]
	    Point[0,0].wont_equal one
	    subject.wont_equal Point[0,0]
	end

	it 'must not be equal to a Point not at the origin' do
	    one.wont_equal Point[3,2]
	    Point[3,2].wont_equal one
	end

	it 'must be equal to a Point of ones' do
	    one.must_be :==, Point[1,1]
	    one.must_be :eql?, Point[1,1]
	    one.must_be :===, Point[1,1]
	    Point[1,1].must_equal one
	    one.must_equal Point[1,1]
	end

	it 'must be equal to an Vector of ones' do
	    one.must_be :eql?, Vector[1, 1]
	    Vector[1, 1].must_equal one
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
