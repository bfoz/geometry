require 'minitest/autorun'
require 'geometry/point_iso'

describe Geometry::PointIso do
    let(:value) { 5 }
    subject { Geometry::PointIso.new(5) }

    it 'must pop' do
	subject.pop.must_equal Point[5]
	subject.pop(2).must_equal Point[5, 5]
    end

    it 'must shift' do
	subject.shift.must_equal Point[5]
	subject.shift(2).must_equal Point[5, 5]
    end

    describe 'minmax' do
	it 'must have a minimum' do
	    subject.min.must_equal 5
	end

	it 'must minimum with another Point' do
	    subject.min(Point[4,7]).must_equal Point[4,5]
	    subject.min(Point[4,7]).must_be_kind_of Point
	end

	it 'must minimum with an Array' do
	    subject.min([4,7]).must_equal Point[4,5]
	end

	it 'must minimum with a multiple arguments' do
	    subject.min(4,7).must_equal Point[4,5]
	end

	it 'must have a maximum' do
	    subject.max.must_equal 5
	end

	it 'must maximum with another Point' do
	    subject.max(Point[7,2]).must_equal Point[7,5]
	    subject.max(Point[7,2]).must_be_kind_of Point
	end

	it 'must maximum with an Array' do
	    subject.max([7,2]).must_equal Point[7,5]
	end

	it 'must maximum with multiple arguments' do
	    subject.max(7,2).must_equal Point[7,5]
	end

	it 'must have a minmax' do
	    subject.minmax.must_equal [5,5]
	end

	it 'must minmax with another Point' do
	    subject.minmax(Point[7,2]).must_equal [Point[5,2], Point[7,5]]
	end

	it 'must minmax with an Array' do
	    subject.minmax([7,2]).must_equal [Point[5,2], Point[7,5]]
	end

	it 'must maximum with multiple arguments' do
	    subject.minmax(7,2).must_equal [Point[5,2], Point[7,5]]
	end
    end

    describe 'arithmetic' do
	let(:left) { Point[1,2] }
	let(:right) { Point[3,4] }

	it 'must pretend to be a Point' do
	    subject.is_a?(Point).must_equal true
	    subject.kind_of?(Point).must_equal true

	    subject.is_a?(Geometry::PointIso).must_equal true
	    subject.kind_of?(Geometry::PointIso).must_equal true

	    subject.instance_of?(Point).must_equal false
	    subject.instance_of?(Geometry::PointIso).must_equal true
	end

	it 'must have +@' do
	    (+subject).must_be :eql?, value
	    (+subject).must_be_instance_of(Geometry::PointIso)
	end

	it 'must have unary negation' do
	    (-subject).must_be :eql?, -value
	    (-subject).must_be_instance_of(Geometry::PointIso)
	end

	describe 'Accessors' do
	    it 'must return 1 for array access' do
		subject[3].must_equal value
	    end

	    it 'must return 1 for named element access' do
		subject.x.must_equal value
		subject.y.must_equal value
		subject.z.must_equal value
	    end
	end

	it 'must add a number' do
	    (subject + 3).must_equal (value + 3)
	    (3 + subject).must_equal (3 + value)
	end

	it 'return a Point when adding two Points' do
	    (subject + right).must_be_kind_of Point
	    (left + subject).must_be_kind_of Point
	end

	it 'must return an Array when adding an array' do
	    (subject + [5,6]).must_equal [value+5, value+6]
#	    ([5,6] + subject).must_equal [10, 11]
	end

	it 'must return a Point when adding a Size' do
	    (subject + Size[5,6]).must_be_instance_of(Point)
	    (subject + Size[5,6]).must_equal Point[value+5, value+6]
	end

	describe 'when subtracting' do
	    it 'must subtract a number' do
		(subject - 3).must_equal (value - 3)
		(3 - subject).must_equal -2
	    end

	    it 'return a Point when subtracting two Points' do
		(subject - right).must_equal Point[value - right.x, value - right.y]
		(left - subject).must_equal Point[left.x - value, left.y - value]
	    end

	    it 'must return a Point when subtracting an array' do
		(subject - [5,6]).must_equal [0, -1]
#		([5,6] - subject).must_equal [4,5]
	    end

	    it 'must return a Point when subtracting a Size' do
		(subject - Size[5,6]).must_be_instance_of(Point)
		(subject - Size[5,6]).must_equal Point[0,-1]
	    end
	end

	it 'must multiply by a scalar' do
	    (subject * 3).must_equal 15
	    (subject * 3.0).must_equal 15.0
	end

	it 'must refuse to multiply by a Point' do
	    -> { subject * Point[1, 2] }.must_raise Geometry::OperationNotDefined
	end

	it 'must refuse to multiply by a Vector' do
	    -> { subject * Vector[2, 3] }.must_raise Geometry::OperationNotDefined
	end

	it 'must divide by a scalar' do
	    (subject / 3).must_equal 5/3
	    (subject / 4.0).must_equal 5/4.0
	end

	it 'must raise an exception when divided by 0' do
	    -> { subject / 0 }.must_raise ZeroDivisionError
	end

	describe 'division' do
	    it 'must raise an exception for Points' do
		lambda { subject / Point[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	    it 'must raise an exception for Vectors' do
		lambda { subject / Vector[1,2] }.must_raise Geometry::OperationNotDefined
	    end
	end
    end

    describe 'coercion' do
	it 'must coerce Arrays into Points' do
	    subject.coerce([3,4]).must_equal [Point[3,4], Point[5, 5]]
	end

	it 'must coerce Vectors into Vectors' do
	    subject.coerce(Vector[3,4]).must_equal [Vector[3,4], Vector[5, 5]]
	end

	it 'must coerce Points into Points' do
	    subject.coerce(Point[5,6]).must_equal [Point[5,6], Point[5, 5]]
	end
    end

    describe 'comparison' do
	it 'must be equal to the same value' do
	    subject.must_be :eql?, 5
	    subject.must_be :eql?, 5.0
	end

	it 'must not be equal to a number of a different value' do
	    0.wont_equal subject
	    3.14.wont_equal subject
	end

	it 'must be equal to an Array of the same value' do
	    subject.must_be :==, [5,5]
	    subject.must_be :eql?, [5,5]
	    subject.must_be :===, [5,5]
	    [5,5].must_equal subject
	    subject.must_equal [5,5]
	end

	it 'must not be equal to an Array of other values' do
	    subject.wont_equal [3, 2, 1]
	    [3, 2, 1].wont_equal subject
	end

	it 'must not be equal to a Point at the origin' do
	    subject.wont_be :==, Point[0,0]
	    subject.wont_be :eql?, Point[0,0]
	    subject.wont_be :===, Point[0,0]
	    Point[0,0].wont_equal subject
	    subject.wont_equal Point[0,0]
	end

	it 'must not be equal to a Point not at the origin' do
	    subject.wont_equal Point[3,2]
	    Point[3,2].wont_equal subject
	end

	it 'must be equal to a Point of subjects' do
	    subject.must_be :==, Point[value, value]
	    subject.must_be :eql?, Point[value, value]
	    subject.must_be :===, Point[value, value]
	    Point[value, value].must_equal subject
	    subject.must_equal Point[value, value]
	end

	it 'must be equal to an Vector of the same value' do
	    subject.must_be :eql?, Vector[value, value]
	    Vector[5, 5].must_equal subject
	end

	it 'must not be equal to a Vector of other values' do
	    subject.wont_equal Vector[3,2]
	    Vector[3,2].wont_equal subject
	end
    end
end
