require 'minitest/autorun'
require 'geometry/square'

describe Geometry::Square do
    describe "when constructed" do
	it "must create a Square from two Points" do
	    square = Geometry::Square.new [1,2], [3,4]
	    square.must_be_kind_of Geometry::Square
	end
	
	it "must reorder swapped points when constructed from two Points" do
	    square = Geometry::Square.new [3,4], [1,2]
	    square.must_be_kind_of Geometry::Square
	    square.instance_eval('@points[0]').must_equal Point[1,2]
	    square.instance_eval('@points[1]').must_equal Point[3,4]
	end
    end
    
    describe "properties" do
	let(:square) { Geometry::Square.new [2,3], [3,4] }

	it "must have an origin accessor" do
	    square.origin.must_equal Point[2,3]
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
	    square.points.must_equal [Point[0,1], Point[0,5], Point[4,5], Point[4,1]]
	end

	it "must have a height property" do
	    square.height.must_equal 4
	end

	it "must have a width property" do
	    square.width.must_equal 4
	end
    end
end
