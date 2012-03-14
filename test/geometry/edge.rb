require_relative '../helper'
require_relative '../../lib/geometry/edge'

class EdgeTest < Test::Unit::TestCase
    must "create an Edge object" do
	edge = Geometry::Edge.new([0,0], [1,0])
	assert_kind_of(Geometry::Edge, edge)
	assert_equal(Geometry::Point[0,0], edge.first)
	assert_equal(Geometry::Point[1,0], edge.last)
    end
    must "create swap endpoints in place" do
	edge = Geometry::Edge.new([0,0], [1,0])
	assert_kind_of(Geometry::Edge, edge)
	edge.reverse!
	assert_equal(Geometry::Point[1,0], edge.first)
	assert_equal(Geometry::Point[0,0], edge.last)
    end
    must "handle equality" do
	edge1 = Geometry::Edge.new([1,0], [0,1])
	edge2 = Geometry::Edge.new([1,0], [0,1])
	edge3 = Geometry::Edge.new([1,1], [5,5])
	assert_equal(edge1, edge2)
	assert_not_equal(edge1, edge3)
    end
end
