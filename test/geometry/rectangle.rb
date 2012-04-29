require_relative '../helper'
require_relative '../../lib/geometry/rectangle'

def Rectangle(*args)
    Geometry::Rectangle.new(*args)
end

Point = Geometry::Point
Size = Geometry::Size

class RectangleConstructorTest < Test::Unit::TestCase

    must "create a Rectangle object from two Points" do
	rectangle = Rectangle [1,2], [3,4]
	assert_kind_of(Geometry::Rectangle, rectangle)
    end

    must "create a Rectangle from a width and height" do
	rectangle = Rectangle 2, 3
	assert_kind_of(Geometry::Rectangle, rectangle)
	assert_equal(2, rectangle.width)
	assert_equal(3, rectangle.height)
	assert_equal(Point[0,0], rectangle.center)
    end

    must "create a Rectangle from a Size" do
	rectangle = Rectangle Size[2, 3]
	assert_kind_of(Geometry::Rectangle, rectangle)
	assert_equal(2, rectangle.width)
	assert_equal(3, rectangle.height)
	assert_equal(Point[0,0], rectangle.center)
    end

    must "create a Rectangle from an origin Point and Size" do
	rectangle = Rectangle Point[1,2], Size[2, 3]
	assert_kind_of(Geometry::Rectangle, rectangle)
	assert_equal(2, rectangle.width)
	assert_equal(3, rectangle.height)
	assert_equal(Point[1,2], rectangle.origin)
    end

    must "create a Rectangle from sides" do
	rectangle = Rectangle 1,2,3,4
	assert_kind_of(Geometry::Rectangle, rectangle)
	assert_equal(2, rectangle.width)
	assert_equal(2, rectangle.height)
	assert_equal(Point[1,2], rectangle.origin)
    end
end

class RectangleTest < Test::Unit::TestCase
    def setup
	@rectangle = Rectangle [1,2], [3,4]
    end

    must "have a center point property" do
	assert_equal(@rectangle.center, [2,3])
    end

    must "have a width property" do
	assert_equal(2, @rectangle.width)
    end

    must "have a height property" do
	assert_equal(2, @rectangle.height)
    end

    must "have an origin property" do
	assert_equal(Point[1,2], @rectangle.origin)
    end
end
