require 'minitest/autorun'
require 'geometry/path'

describe Geometry::Path do
    describe "construction" do
	it "must create a Path with no arguments" do
	    path = Geometry::Path.new
	    path.must_be_kind_of Geometry::Path
	    path.elements.wont_be_nil
	    path.elements.size.must_equal 0
	end

	it "must create a Path from Points" do
	    path = Geometry::Path.new Point[1,1], Point[2,2], Point[3,3]
	    path.elements.size.must_equal 2
	    path.elements.each {|a| a.must_be_kind_of Geometry::Edge }
	end

	it "with connected Edges" do
	    path = Geometry::Path.new Edge.new([1,1], [2,2]), Edge.new([2,2], [3,3])
	    path.elements.size.must_equal 2
	    path.elements.each {|a| a.must_be_kind_of Geometry::Edge }
	end

	it "with disjoint Edges" do
	    path = Geometry::Path.new Edge.new([1,1], [2,2]), Edge.new([3,3], [4,4])
	    path.elements.size.must_equal 3
	    path.elements.each {|a| a.must_be_kind_of Geometry::Edge }
	end

	it "with Points and Arcs" do
	    path = Geometry::Path.new [0,0], [1.0,0.0], Arc.new(center:[1,1], radius:1, start:-90*Math::PI/180, end:0), [2.0,1.0], [1,2]
	    path.elements.size.must_equal 3
	    path.elements[0].must_be_kind_of Geometry::Edge
	    path.elements[1].must_be_kind_of Geometry::Arc
	    path.elements[2].must_be_kind_of Geometry::Edge
	end

	it "with Edges and Arcs" do
	    path = Geometry::Path.new Edge.new([0,0], [1.0,0.0]), Arc.new(center:[1,1], radius:1, start:-90*Math::PI/180, end:0), Edge.new([2.0,1.0], [1,2])
	    path.elements.size.must_equal 3
	    path.elements[0].must_be_kind_of Geometry::Edge
	    path.elements[1].must_be_kind_of Geometry::Arc
	    path.elements[2].must_be_kind_of Geometry::Edge
	end

	it "with disjoint Edges and Arcs" do
	    path = Geometry::Path.new Edge.new([0,0], [1,0]), Arc.new(center:[2,1], radius:1, start:-90*Math::PI/180, end:0), Edge.new([3,1], [1,2])
	    path.elements.size.must_equal 4
	    path.elements[0].must_be_kind_of Geometry::Edge
	    path.elements[1].must_be_kind_of Geometry::Edge
	    path.elements[2].must_be_kind_of Geometry::Arc
	    path.elements[3].must_be_kind_of Geometry::Edge
	end

	it "with disjoint Arcs" do
	    path = Geometry::Path.new Arc.new(center:[2,1], radius:1, start:-90*Math::PI/180, end:0), Arc.new(center:[3,1], radius:1, start:-90*Math::PI/180, end:0)
	    path.elements.size.must_equal 3
	    path.elements[0].must_be_kind_of Geometry::Arc
	    path.elements[1].must_be_kind_of Geometry::Edge
	    path.elements[2].must_be_kind_of Geometry::Arc

	    path.elements[0].last.must_equal path.elements[1].first
	end
    end
end
