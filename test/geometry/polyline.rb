require 'minitest/autorun'
require 'geometry/polyline'

describe Geometry::Polyline do
    Polyline = Geometry::Polyline

    let(:unit_square) { Polyline.new [0,0], [1,0], [1,1], [0,1] }

    it "must create a Polyline object with no arguments" do
	polyline = Geometry::Polyline.new
	polyline.must_be_kind_of Polyline
	polyline.edges.count.must_equal 0
	polyline.vertices.count.must_equal 0
    end

    it "must create a Polyline object from array arguments" do
	polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	polyline.must_be_kind_of Polyline
	polyline.edges.count.must_equal 3
	polyline.vertices.count.must_equal 4
    end

    describe "when creating a Polyline from an array of Points" do
	it "must ignore repeated Points" do
	    polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [1,1], [0,1])
	    polyline.must_be_kind_of Geometry::Polyline
	    polyline.must_equal Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse collinear Edges" do
	    polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0.5,1], [0,1])
	    polyline.must_equal Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse backtracking Edges" do
	    polyline = Geometry::Polyline.new [0,0], [2,0], [2,2], [1,2], [1,1], [1,2], [0,2]
	    polyline.must_equal Geometry::Polyline.new([0,0], [2,0], [2,2], [0,2])
	end
    end

    it "must compare identical polylines as equal" do
	(unit_square.eql? unit_square).must_equal true
    end

    describe "when offsetting" do
	describe "with a positive offset" do
	    it "must leftset a unit square" do
		expected_polyline = Polyline.new [0,0.1], [0.9,0.1], [0.9,0.9], [0,0.9]
		unit_square.offset(0.1).must_equal expected_polyline
	    end

	    it "must leftset a simple concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,4], [3,4], [3,3], [1,3], [1,4], [0,4]
		offset_polyline = concave_polyline.offset(1)
		offset_polyline.must_equal Polyline.new [0,1], [3,1], [3,2], [0,2], [0,3]
	    end
	end

	describe "with a negative offset" do
	    it "must rightset a unit square" do
		expected_polyline = Polyline.new [0,-1.0], [2.0,-1.0], [2.0,2.0], [0,2.0]
		unit_square.offset(-1).must_equal expected_polyline
	    end

	    it "must rightset a simple concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-1)
		offset_polyline.must_equal Polyline.new [0,-1], [5,-1], [5,3], [0,3]
	    end

	    it "must rightset a concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [6,-2], [6,4], [0,4]
	    end

	    it "must rightset an asymetric concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,3], [3,3], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [6,-2], [6,5], [1,5], [1,4], [0,4]
	    end

	    it "must rightset a concave polyline with multiply-intersecting edges" do
		concave_polyline = Polyline.new [0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [7,-2], [7,4], [0,4]
	    end
	end
    end
end
