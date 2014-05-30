require 'minitest/autorun'
require 'geometry/size_zero'

describe Geometry::SizeZero do
    Size = Geometry::Size

    let(:zero) { Geometry::SizeZero.new }

    describe "arithmetic" do
	let(:left) { Size[1,2] }
	let(:right) { Size[3,4] }
	
	it "must have +@" do
	    (+zero).must_be :eql?, 0
	    (+zero).must_be_instance_of(Geometry::SizeZero)
	end
	
	it "must have unary negation" do
	    (-zero).must_be :eql?, 0
	    (-zero).must_be_instance_of(Geometry::SizeZero)
	end
	
	describe "when adding" do
	    it "must return a number" do
		(zero + 3).must_equal 3
		(3 + zero).must_equal 3
	    end

	    it "return a Size when adding two Sizes" do
		(zero + right).must_be_kind_of Size
#		(left + zero).must_be_kind_of Size
	    end
	    
	    it "must return a Size when adding an array" do
		(zero + [5,6]).must_equal [5,6]
#		([5,6] + zero).must_equal [5,6]
	    end
	end
	
	describe "when subtracting" do
	    it "must return a number" do
		(zero - 3).must_equal -3
		(3 - zero).must_equal 3
	    end

	    it "return a Size when subtracting two Size" do
		(zero - right).must_equal Size[-3,-4]
		(left - zero).must_equal Size[1,2]
	    end
	    
	    it "must return a Size when subtracting an array" do
		(zero - [5,6]).must_equal [-5, -6]
#		([5,6] - zero).must_equal [5,6]
	    end
	end
	
	describe "multiplication" do
	    it "must return 0 for scalars" do
		(zero * 3).must_equal 0
		(zero * 3.0).must_equal 0.0
	    end

	    it "must return 0 for Sizes" do
		(zero * Size[1,2]).must_equal 0
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

	    it "must raise an exception for Sizes" do
		lambda { zero / Size[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	    it "must raise an exception for Vectors" do
		lambda { zero / Vector[1,2] }.must_raise Geometry::OperationNotDefined
	    end

	end

    end

    describe "coercion" do
	it "must coerce Arrays into Sizes" do
	    zero.coerce([3,4]).must_equal [Size[3,4], Size[0,0]]
	end
	
	it "must coerce Vectors into Vectors" do
	    zero.coerce(Vector[3,4]).must_equal [Vector[3,4], Vector[0,0]]
	end

	it "must coerce Size into Size" do
	    zero.coerce(Size[5,6]).must_equal [Size[5,6], Size[0,0]]
	end
    end

    describe "comparison" do
	let(:zero) { Geometry::PointZero.new }
	
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
	    [0,0].must_equal zero
	end
	
	it "must not be equal to a non-zero Array" do
	    zero.wont_equal [3,2]
	    [3,2].wont_equal zero
	end
	
	it "must be equal to a zero Size" do
	    zero.must_be :==, Size[0,0]
	    zero.must_be :eql?, Size[0,0]
	    Size[0,0].must_equal zero
	end
	
	it "must not be equal to a non-zero Size" do
	    zero.wont_equal Size[3,2]
	    Size[3,2].wont_equal zero
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
	    zero.first.must_equal 0
	    zero.first(1).must_equal [0]
	    zero.first(5).must_equal [0,0,0,0,0]
	end
    end
end
