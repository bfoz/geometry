require 'minitest/autorun'
require 'geometry/square'

describe Geometry::Square do
    Square = Geometry::Square

    describe "when constructed" do
	it "must create a Square from two Points" do
	    square = Square.new from:[1,2], to:[3,4]
	    square.must_be_kind_of Geometry::Square
	end
	
	it "must reorder swapped points when constructed from two Points" do
	    square = Geometry::Square.new from:[3,4], to:[1,2]
	    square.must_be_kind_of Geometry::Square
	    square.instance_eval('@points[0]').must_equal Point[1,2]
	    square.instance_eval('@points[1]').must_equal Point[3,4]
	end

	it "must accept an origin Point and a size" do
	    square = Square.new origin:[1,2], size:5
	    square.must_be_kind_of Geometry::Square
	    square.origin.must_equal Point[1,2]
	    square.height.must_equal 5
	    square.width.must_equal 5
	end
    end
    
    describe "properties" do
	subject { Square.new from:[2,3], to:[3,4] }

	it "must have an origin accessor" do
	    subject.origin.must_equal Point[2,3]
	end
    end
end

describe Geometry::CenteredSquare do
    describe "when constructed" do
	it "must create a CenteredSquare from a center point and a size" do
	    square = Geometry::CenteredSquare.new [2,3], 5
	    square.must_be_instance_of Geometry::CenteredSquare
	    square.must_be_kind_of Geometry::Square
	end
    end

    describe "properties" do
	let(:square) { Geometry::CenteredSquare.new [2,3], 4 }
	
	it "must have a center property" do
	    square.center.must_equal Point[2,3]
	end

	it "must have a points property" do
	    square.points.must_equal [Point[0,1], Point[4,1], Point[4,5], Point[0,5]]
	end

	it "must have a height property" do
	    square.height.must_equal 4
	end

	it "must have a width property" do
	    square.width.must_equal 4
	end
    end
end
