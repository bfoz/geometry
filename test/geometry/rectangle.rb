require 'minitest/autorun'
require 'geometry/rectangle'

def Rectangle(*args)
    Geometry::Rectangle.new(*args)
end

describe Geometry::Rectangle do
    Point = Geometry::Point
    Rectangle = Geometry::Rectangle

    describe "when initializing" do
	it "must accept two corners as Arrays" do
	    rectangle = Rectangle.new [1,2], [2,3]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.height.must_equal 1
	    rectangle.width.must_equal 1
	    rectangle.origin.must_equal Point[1,2]
	end

	it "must accept two named corners as Arrays" do
	    rectangle = Rectangle.new from:[1,2], to:[2,3]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.height.must_equal 1
	    rectangle.width.must_equal 1
	    rectangle.origin.must_equal Point[1,2]
	end

	it "must accept named center point and size arguments" do
	    rectangle = Rectangle.new center:[1,2], size:[3,4]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.height.must_equal 4
	    rectangle.width.must_equal 3
	    rectangle.center.must_equal Point[1,2]
	end

	it "must reject a named center argument with no size argument" do
	    -> { Rectangle.new center:[1,2] }.must_raise ArgumentError
	end

	it "must accept named origin point and size arguments" do
	    rectangle = Rectangle.new origin:[1,2], size:[3,4]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.height.must_equal 4
	    rectangle.width.must_equal 3
	    rectangle.origin.must_equal Point[1,2]
	end

	it "must reject a named origin argument with no size argument" do
	    -> { Rectangle.new origin:[1,2] }.must_raise ArgumentError
	end

	it "must accept a sole named size argument that is an Array" do
	    rectangle = Rectangle.new size:[1,2]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.origin.must_equal Point[0,0]
	    rectangle.height.must_equal 2
	    rectangle.width.must_equal 1
	end

	it "must accept a sole named size argument that is a Size" do
	    rectangle = Rectangle.new size:Size[1,2]
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.origin.must_equal Point[0,0]
	    rectangle.height.must_equal 2
	    rectangle.width.must_equal 1
	end

	it "must accept named width and height arguments" do
	    rectangle = Rectangle.new width:1, height:3
	    rectangle.must_be_kind_of Geometry::Rectangle
	    rectangle.height.must_equal 3
	    rectangle.width.must_equal 1
	end

	it "must reject width or height by themselves" do
	    -> { Rectangle.new height:1 }.must_raise ArgumentError
	    -> { Rectangle.new width:1 }.must_raise ArgumentError
	end

    end

    describe "comparison" do
	it "must compare equal" do
	    rectangle = Rectangle [1,2], [3,4]
	    rectangle.must_equal Rectangle([1,2], [3, 4])
	end
    end

    describe "properties" do
	let(:rectangle) { Rectangle [1,2], [3,4] }

	it "have a center point property" do
	    rectangle.center.must_equal Point[2,3]
	end

	it "have a width property" do
	    assert_equal(2, rectangle.width)
	end

	it "have a height property" do
	    assert_equal(2, rectangle.height)
	end

	it "have an origin property" do
	    assert_equal(Point[1,2], rectangle.origin)
	end

	it "have an edges property that returns 4 edges" do
	    edges = rectangle.edges
	    assert_equal(4, edges.size)
	    edges.each {|edge| assert_kind_of(Geometry::Edge, edge)}
	end

	it "have a points property that returns 4 points" do
	    points = rectangle.points
	    assert_equal(4, points.size)
	    points.each {|point| assert_kind_of(Geometry::Point, point)}
	end
    end
end
