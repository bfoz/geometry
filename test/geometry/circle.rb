require_relative '../helper'
require_relative '../../lib/geometry/circle'

def Circle(*args)
    Geometry::Circle.new(*args)
end

class CircleTest < Test::Unit::TestCase
    must "create a Circle object from a Point and a radius" do
	circle = Circle [1,2], 3
	assert_kind_of(Geometry::Circle, circle)
    end

    must "have a center point accessor" do
	circle = Circle [1,2], 3
	assert_equal(circle.center, [1,2])
    end

    must "have a radius accessor" do
	circle = Circle [1,2], 3
	assert_equal(3, circle.radius)
    end
end
