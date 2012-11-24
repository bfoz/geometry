require 'minitest/autorun'
require 'geometry/polygon'

describe Geometry::Polygon do
    Polygon = Geometry::Polygon

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

end
