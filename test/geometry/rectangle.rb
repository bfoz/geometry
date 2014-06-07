require 'minitest/autorun'
require 'geometry/rectangle'

def Rectangle(*args)
    Geometry::Rectangle.new(*args)
end

describe Geometry::Rectangle do
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

    describe "inset" do
	subject { Rectangle.new [0,0], [10,10] }

	it "must inset equally" do
	    subject.inset(1).must_equal Rectangle.new [1,1], [9,9]
	end

	it "must inset vertically and horizontally" do
	    subject.inset(1,2).must_equal Rectangle.new [1,2], [9,8]
	    subject.inset(x:1, y:2).must_equal Rectangle.new [1,2], [9,8]
	end

	it "must inset from individual sides" do
	    subject.inset(1,2,3,4).must_equal Rectangle.new [2,3], [6,9]
	    subject.inset(top:1, left:2, bottom:3, right:4).must_equal Rectangle.new [2,3], [6,9]
	end
    end

    describe "properties" do
	subject { Rectangle.new [1,2], [3,4] }
	let(:rectangle) { Rectangle [1,2], [3,4] }

	it "have a center point property" do
	    rectangle.center.must_equal Point[2,3]
	end

	it 'must always be closed' do
	    subject.closed?.must_equal true
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

	it "must have a bounds property that returns a Rectangle" do
	    subject.bounds.must_equal Rectangle.new([1,2], [3,4])
	end

	it "must have a minmax property that returns the corners of the bounding rectangle" do
	    subject.minmax.must_equal [Point[1,2], Point[3,4]]
	end

	it "must have a max property that returns the upper right corner of the bounding rectangle" do
	    subject.max.must_equal Point[3,4]
	end

	it "must have a min property that returns the lower left corner of the bounding rectangle" do
	    subject.min.must_equal Point[1,2]
	end
    end
end
