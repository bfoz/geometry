require_relative '../helper'
require_relative '../../lib/geometry/polygon'

class PolygonTest < Test::Unit::TestCase
    must "create a Polygon object" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	assert_kind_of(Geometry::Polygon, polygon)
	assert_equal(4, polygon.edges.size)
	assert_equal(4, polygon.vertices.size)
    end
    must "create closed polygons" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
	assert_equal(polygon.edges.first.first, polygon.edges.last.last)
    end
    must "handle already closed polygons" do
	polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1], [0,0])
	assert_kind_of(Geometry::Polygon, polygon)
	assert_equal(4, polygon.edges.size)
	assert_equal(4, polygon.vertices.size)
	assert_equal(polygon.edges.first.first, polygon.edges.last.last)
    end
end
