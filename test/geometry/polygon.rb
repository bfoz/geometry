require 'minitest/autorun'
require 'geometry/polygon'

describe Geometry::Polygon do
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
end
