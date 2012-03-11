require_relative 'helper'
require_relative '../lib/geometry/line'

class PointTest < Test::Unit::TestCase
    must "create a Line object from 2 Points" do
	line = Geometry::Line[Geometry::Point[0,0], Geometry::Point[10,10]]
	assert_kind_of(Geometry::Line, line)
	assert_kind_of(Geometry::TwoPointLine, line)
    end
    must "create a Line object from two arrays" do
	line = Geometry::Line[[0,0], [10,10]]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::TwoPointLine, line)
	assert_kind_of(Geometry::Point, line.first)
	assert_kind_of(Geometry::Point, line.last)
    end
    must "create a Line object from two Vectors" do
	line = Geometry::Line[Vector[0,0], Vector[10,10]]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::TwoPointLine, line)
    end

    must "create a Line from a slope and y-intercept" do
	line = Geometry::Line[0.75, 5]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::SlopeInterceptLine, line)
	assert_equal(5, line.intercept)
	assert_equal(0.75, line.slope)
    end

    must "create a Line from a Rational slope and y-intercept" do
	line = Geometry::Line[Rational(3,4), 5]
	assert_kind_of(Geometry::SlopeInterceptLine, line)
	assert(line.is_a?(Geometry::Line))
	assert_equal(Rational(3,4), line.slope)
    end

    must "have a special constructor for horizontal lines" do
	line = Geometry::Line.horizontal
	assert(line.horizontal?)
    end
    must "have a special constructor for vertical lines" do
	line = Geometry::Line.vertical
	assert(line.vertical?)
    end

    must "have accessor for y-intercept" do
	line = Geometry::Line[0.75, 5]
	assert_equal(5, line.intercept)
	assert_equal(5, line.intercept(:y))
    end
    must "have accessor for x-intercept" do
	line = Geometry::Line.vertical(7)
	assert_equal(7, line.intercept(:x))
    end

    must "return the correct x-intercept for vertical lines" do
	line = Geometry::Line.vertical(7)
	assert_equal(7, line.intercept(:x))
    end
    must "return the correct y-intercept for horizontal lines" do
	line = Geometry::Line.horizontal(4)
	assert_equal(4, line.intercept(:y))
    end

    must "return nil x-intercept for horizontal lines" do
	line = Geometry::Line.horizontal
	assert_nil(line.intercept(:x))
    end
    must "return nil y-intercept for vertical lines" do
	line = Geometry::Line.vertical
	assert_nil(line.intercept(:y))
    end

    must "implement inspect" do
	line = Geometry::Line[[0,0], [10,10]]
	assert_equal('Line(Point[0, 0], Point[10, 10])', line.inspect)
    end
    must "implement to_s" do
	line = Geometry::Line[[0,0], [10,10]]
	assert_equal('Line(Point[0, 0], Point[10, 10])', line.to_s)
    end
end
