require 'minitest/autorun'
require 'geometry/edge'

def Edge(*args)
    Geometry::Edge.new(*args)
end

describe Geometry::Edge do
    Edge = Geometry::Edge

    it "must create an Edge object" do
	edge = Edge.new([0,0], [1,0])
	assert_kind_of(Geometry::Edge, edge)
	assert_equal(Geometry::Point[0,0], edge.first)
	assert_equal(Geometry::Point[1,0], edge.last)
    end
    it "must create swap endpoints in place" do
	edge = Edge.new([0,0], [1,0])
	assert_kind_of(Edge, edge)
	edge.reverse!
	assert_equal(Geometry::Point[1,0], edge.first)
	assert_equal(Geometry::Point[0,0], edge.last)
    end
    it "must handle equality" do
	edge1 = Edge.new([1,0], [0,1])
	edge2 = Edge.new([1,0], [0,1])
	edge3 = Edge.new([1,1], [5,5])
	assert_equal(edge1, edge2)
	edge1.wont_equal edge3
    end

    it "must return the height of the edge" do
	edge = Edge([0,0], [1,1])
	assert_equal(1, edge.height)
    end

    it "must return the width of the edge" do
	edge = Edge([0,0], [1,1])
	assert_equal(1, edge.width)
    end
end
