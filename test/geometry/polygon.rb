require 'minitest/autorun'
require 'geometry/polygon'

describe Geometry::Polygon do
    Point = Geometry::Point
    Polygon = Geometry::Polygon

    let(:cw_unit_square) { Polygon.new [0,0], [0,1], [1,1], [1,0] }
    let(:unit_square) { Polygon.new [0,0], [1,0], [1,1], [0,1] }

    it "must create a Polygon object with no arguments" do
	polygon = Geometry::Polygon.new
	assert_kind_of(Geometry::Polygon, polygon)
	assert_equal(0, polygon.edges.size)
	assert_equal(0, polygon.vertices.size)
    end

    it "must create a Polygon object from array arguments" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	assert_kind_of(Geometry::Polygon, polygon)
	assert_equal(4, polygon.edges.size)
	assert_equal(4, polygon.vertices.size)
    end

    describe "when creating a Polygon from an array of Points" do
	it "must ignore repeated Points" do
	    polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [1,1], [0,1])
	    polygon.must_be_kind_of Geometry::Polygon
	    polygon.edges.size.must_equal 4
	    polygon.vertices.size.must_equal 4
	    polygon.must_equal Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse collinear Edges" do
	    polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0.5,1], [0,1])
	    polygon.must_equal Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse backtracking Edges" do
	    polygon = Geometry::Polygon.new [0,0], [2,0], [2,2], [1,2], [1,1], [1,2], [0,2]
	    polygon.must_equal Geometry::Polygon.new([0,0], [2,0], [2,2], [0,2])
	end
    end

    it "must compare identical polygons as equal" do
	(unit_square.eql? unit_square).must_equal true
    end

    it "must create closed polygons" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	assert_equal(polygon.edges.first.first, polygon.edges.last.last)
    end

    it "must handle already closed polygons" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1], [0,0])
	assert_kind_of(Geometry::Polygon, polygon)
	assert_equal(4, polygon.edges.size)
	assert_equal(4, polygon.vertices.size)
	assert_equal(polygon.edges.first.first, polygon.edges.last.last)
    end

    it "must gift wrap a square polygon" do
	polygon = Polygon.new [0,0], [1,0], [1,1], [0,1]
	convex_hull = polygon.wrap
	convex_hull.must_be_kind_of Geometry::Polygon
	convex_hull.edges.size.must_equal 4
	convex_hull.vertices.must_equal [[0,0], [0,1], [1,1], [1,0]].map {|a| Point[*a]}
    end

    it "must gift wrap another square polygon" do
	polygon = Polygon.new [0,1], [0,0], [1,0], [1,1]
	convex_hull = polygon.wrap
	convex_hull.must_be_kind_of Geometry::Polygon
	convex_hull.edges.size.must_equal 4
	convex_hull.vertices.must_equal [[0,0], [0,1], [1,1], [1,0]].map {|a| Point[*a]}
    end

    it "must gift wrap a concave polygon" do
	polygon = Polygon.new [0,0], [1,-1], [2,0], [1,1], [2,2], [0,1]
	convex_hull = polygon.wrap
	convex_hull.must_be_kind_of Geometry::Polygon
	convex_hull.edges.size.must_equal 5
	convex_hull.vertices.must_equal [Point[0, 0], Point[0, 1], Point[2, 2], Point[2, 0], Point[1, -1]]
    end

    it "must gift wrap a polygon" do
	polygon = Polygon.new [0,0], [1,-1], [2,0], [2,1], [0,1]
	convex_hull = polygon.wrap
	convex_hull.must_be_kind_of Geometry::Polygon
	convex_hull.edges.size.must_equal 5
	convex_hull.vertices.must_equal [[0,0], [0,1], [2,1], [2,0], [1,-1]].map {|a| Point[*a]}
    end

    describe "when outsetting" do
	it "must outset a unit square" do
	    outset_polygon = unit_square.outset(1)
	    expected_polygon = Polygon.new [-1.0,-1.0], [2.0,-1.0], [2.0,2.0], [-1.0,2.0]
	    outset_polygon.must_equal expected_polygon
	end

	it "must outset a simple concave polygon" do
	    concave_polygon = Polygon.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
	    outset_polygon = concave_polygon.outset(1)
	    outset_polygon.must_equal Polygon.new [-1,-1], [5,-1], [5,3], [-1,3]
	end

	it "must outset a concave polygon" do
	    concave_polygon = Polygon.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
	    outset_polygon = concave_polygon.outset(2)
	    outset_polygon.must_equal Polygon.new [-2,-2], [6,-2], [6,4], [-2,4]
	end

	it "must outset an asymetric concave polygon" do
	    concave_polygon = Polygon.new [0,0], [4,0], [4,3], [3,3], [3,1], [1,1], [1,2], [0,2]
	    outset_polygon = concave_polygon.outset(2)
	    outset_polygon.must_equal Polygon.new [-2,-2], [6,-2], [6,5], [1,5], [1,4], [-2,4]
	end

	it "must outset a concave polygon with multiply-intersecting edges" do
	    concave_polygon = Polygon.new [0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2]
	    outset_polygon = concave_polygon.outset(2)
	    outset_polygon.must_equal Polygon.new [-2,-2], [7,-2], [7,4], [-2,4]
	end
    end
end
