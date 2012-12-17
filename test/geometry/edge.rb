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

    it "must convert an Edge to a Vector" do
	Edge.new([0,0], [1,0]).vector.must_equal Vector[1,0]
    end

    it "must return the normalized direction of a vector" do
	Edge.new([0,0], [1,0]).direction.must_equal Vector[1,0]
    end

    it "must return true for parallel edges" do
	Edge.new([0,0], [1,0]).parallel?(Edge.new([0,0], [1,0])).must_equal 1
	Edge.new([0,0], [1,0]).parallel?(Edge.new([1,0], [2,0])).must_equal 1
	Edge.new([0,0], [1,0]).parallel?(Edge.new([3,0], [4,0])).must_equal 1
	Edge.new([0,0], [1,0]).parallel?(Edge.new([3,1], [4,1])).must_equal 1
    end

    it "must return false for non-parallel edges" do
	Edge.new([0,0], [2,0]).parallel?(Edge.new([1,-1], [1,1])).must_equal false
    end

    describe "spaceship" do
	it "ascending with a Point" do
	    edge = Edge.new [0,0], [1,1]
	    (edge <=> Point[0,0]).must_equal 0
	    (edge <=> Point[1,0]).must_equal -1
	    (edge <=> Point[0,1]).must_equal 1
	    (edge <=> Point[2,2]).must_equal nil
	end

	it "descending with a Point" do
	    edge = Edge.new [1,1], [0,0]
	    (edge <=> Point[0,0]).must_equal 0
	    (edge <=> Point[1,0]).must_equal 1
	    (edge <=> Point[0,1]).must_equal -1
	    (edge <=> Point[2,2]).must_equal nil
	end
    end

    describe "when finding an intersection" do
	it "must find the intersection of two end-intersecting Edges" do
	    intersection = Edge.new([0,0],[1,1]).intersection(Edge.new([0,1],[1,1]))
	    intersection.must_be_kind_of Geometry::Point
	    intersection.must_equal Geometry::Point[1,1]
	end

	it "must find the itersection of two crossed Edges" do
	    edge1 = Edge.new [0.0, 0], [2.0, 2.0]
	    edge2 = Edge.new [2.0, 0], [0.0, 2.0]
	    intersection = edge1.intersection edge2
	    intersection.must_be_kind_of Geometry::Point
	    intersection.must_equal Geometry::Point[1,1]
	end

	it "must return nil for two edges that do not intersect" do
	    Edge.new([0,0],[1,0]).intersection(Edge.new([0,1],[1,1])).must_equal nil
	end

	it "must return true for two collinear and overlapping edges" do
	    Edge.new([0,0],[2,0]).intersection(Edge.new([1,0],[3,0])).must_equal true
	end

	it "must return false for collinear but non-overlapping edges" do
	    Edge.new([0,0],[2,0]).intersection(Edge.new([3,0],[4,0])).must_equal false
	    Edge.new([0,0],[0,2]).intersection(Edge.new([0,3],[0,4])).must_equal false
	end

	it "must return nil for two parallel but not collinear edges" do
	    Edge.new([0,0],[2,0]).intersection(Edge.new([1,1],[3,1])).must_equal nil
	end

	it "must return nil for two perpendicular but not interseting edges" do
	    Edge.new([0, 0], [2, 0]).intersection(Edge.new([3, 3], [3, 1])).must_equal nil
	end
    end
end
