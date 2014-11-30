require 'minitest/autorun'
require 'geometry/point_zero'

describe Geometry::PointZero do
    subject { Geometry::PointZero.new }
    let(:zero) { Geometry::PointZero.new }

    it 'must pop' do
	subject.pop.must_equal Point[0]
	subject.pop(2).must_equal Point[0, 0]
    end

    it 'must shift' do
	subject.shift.must_equal Point[0]
	subject.shift(2).must_equal Point[0, 0]
    end

    describe 'minmax' do
	it 'must have a minimum' do
	    subject.min.must_equal 0
	end

	it 'must minimum with another Point' do
	    subject.min(Point[-1,7]).must_equal Point[-1,0]
	end

	it 'must minimum with an Array' do
	    subject.min([-1,7]).must_equal Point[-1,0]
	end

	it 'must minimum with a multiple arguments' do
	    subject.min(-1,7).must_equal Point[-1,0]
	end

	it 'must have a maximum' do
	    subject.max.must_equal 0
	end

	it 'must maximum with another Point' do
	    subject.max(Point[7,-1]).must_equal Point[7,0]
	end

	it 'must maximum with an Array' do
	    subject.max([7,-1]).must_equal Point[7,0]
	end

	it 'must maximum with multiple arguments' do
	    subject.max(7,-1).must_equal Point[7,0]
	end

	it 'must have a minmax' do
	    subject.minmax.must_equal [0, 0]
	end

	it 'must minmax with another Point' do
	    subject.minmax(Point[7,-1]).must_equal [Point[0,-1], Point[7,0]]
	end

	it 'must minmax with an Array' do
	    subject.minmax([7,-1]).must_equal [Point[0,-1], Point[7,0]]
	end

	it 'must maximum with multiple arguments' do
	    subject.minmax(7,-1).must_equal [Point[0,-1], Point[7,0]]
	end
    end

    describe "arithmetic" do
	let(:left) { Point[1,2] }
	let(:right) { Point[3,4] }

	it 'must pretend to be a Point' do
	    subject.is_a?(Point).must_equal true
	    subject.kind_of?(Point).must_equal true

	    subject.is_a?(PointZero).must_equal true
	    subject.kind_of?(PointZero).must_equal true

	    subject.instance_of?(Point).must_equal false
	    subject.instance_of?(PointZero).must_equal true
	end

	it "must have +@" do
	    (+zero).must_be :eql?, 0
	    (+zero).must_be_instance_of(Geometry::PointZero)
	end
	
	it "must have unary negation" do
	    (-zero).must_be :eql?, 0
	    (-zero).must_be_instance_of(Geometry::PointZero)
	end

	describe "Accessors" do
	    it "must return 0 for array access" do
		zero[3].must_equal 0
	    end

	    it "must return 0 for named element access" do
		zero.x.must_equal 0
		zero.y.must_equal 0
		zero.z.must_equal 0
	    end
	end

	describe "when adding" do
	    it "must return a PointIso when adding a number" do
		(zero + 3).must_equal 3
		(zero + 3).must_be_instance_of Geometry::PointIso
		(3 + zero).must_equal 3
	    end

	    it "return a Point when adding two Points" do
		(zero + right).must_be_kind_of Point
		(left + zero).must_be_kind_of Point
	    end
	    
	    it "must return an Array when adding an array" do
		(zero + [5,6]).must_equal [5,6]
#		([5,6] + zero).must_equal [5,6]
	    end

	    it "must return a Point when adding a Size" do
		(zero + Size[5,6]).must_be_instance_of(Point)
		(zero + Size[5,6]).must_equal Point[5,6]
	    end
	end
	
	describe "when subtracting" do
	    it "must return a number" do
		(zero - 3).must_equal -3
		(3 - zero).must_equal 3
	    end

	    it "return a Point when subtracting two Points" do
		(zero - right).must_equal Point[-3,-4]
		(left - zero).must_equal Point[1,2]
	    end
	    
	    it "must return a Point when subtracting an array" do
		(zero - [5,6]).must_equal [-5, -6]
#		([5,6] - zero).must_equal [5,6]
	    end

	    it "must return a Point when subtracting a Size" do
		(zero - Size[5,6]).must_be_instance_of(Point)
		(zero - Size[5,6]).must_equal Point[-5,-6]
	    end
	end
	
	describe "multiplication" do
	    it "must return 0 for scalars" do
		(zero * 3).must_equal 0
		(zero * 3.0).must_equal 0.0
	    end

	    it "must return 0 for Points" do
		(zero * Point[1,2]).must_equal 0
	    end

	    it "must return 0 for Vectors" do
		(zero * Vector[2,3]).must_equal 0
	    end
	end

	describe "division" do
	    it "must return 0 for non-zero scalars" do
		(zero / 3).must_equal 0
		(zero / 4.0).must_equal 0
	    end

	    it "must raise an exception when divided by 0" do
		lambda { zero / 0 }.must_raise ZeroDivisionError
	    end

	    it "must raise an exception for Points" do
		lambda { zero / Point[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	    it "must raise an exception for Vectors" do
		lambda { zero / Vector[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	end

    end

    describe "coercion" do
	it "must coerce Arrays into Points" do
	    zero.coerce([3,4]).must_equal [Point[3,4], Point[0,0]]
	end
	
	it "must coerce Vectors into Vectors" do
	    zero.coerce(Vector[3,4]).must_equal [Vector[3,4], Vector[0,0]]
	end

	it "must coerce Points into Points" do
	    zero.coerce(Point[5,6]).must_equal [Point[5,6], Point[0,0]]
	end
    end

    describe "comparison" do
	subject { Geometry::PointZero.new }
	
	it "must be equal to 0 and 0.0" do
	    zero.must_be :eql?, 0
	    zero.must_be :eql?, 0.0
	end

	it "must not be equal to a non-zero number" do
	    1.wont_equal zero
	    3.14.wont_equal zero
	end

	it "must be equal to an Array of zeros" do
	    zero.must_be :==, [0,0]
	    zero.must_be :eql?, [0,0]
	    zero.must_be :===, [0,0]
	    [0,0].must_equal zero
	    subject.must_equal [0,0]
	end
	
	it "must not be equal to a non-zero Array" do
	    zero.wont_equal [3,2]
	    [3,2].wont_equal zero
	end
	
	it "must be equal to a Point at the origin" do
	    zero.must_be :==, Point[0,0]
	    zero.must_be :eql?, Point[0,0]
	    zero.must_be :===, Point[0,0]
	    Point[0,0].must_equal zero
	    subject.must_equal Point[0,0]
	end
	
	it "must not be equal to a Point not at the origin" do
	    zero.wont_equal Point[3,2]
	    Point[3,2].wont_equal zero
	end
	
	it "must be equal to an Vector of zeroes" do
	    zero.must_be :eql?, Vector[0,0]
	    Vector[0,0].must_equal zero
	end
	
	it "must not be equal to a non-zero Vector" do
	    zero.wont_equal Vector[3,2]
	    Vector[3,2].wont_equal zero
	end
    end

    describe 'when enumerating' do
	it 'must have a first method' do
	    subject.first.must_equal 0
	    subject.first(1).must_equal [0]
	    subject.first(5).must_equal [0,0,0,0,0]
	end
    end
end
