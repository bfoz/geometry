require 'minitest/autorun'
require 'geometry/polygon'

describe Geometry::Polygon do
    Polygon = Geometry::Polygon

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
