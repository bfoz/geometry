require 'minitest/autorun'
require 'geometry/line'

describe Geometry::Line do
    Line = Geometry::Line
    Point = Geometry::Point

    describe "when initializing" do
	it "must accept two named points" do
	    line = Line.new(from:Point[0,0], to:Point[10,10])
	    line.must_be_kind_of(Line)
	    line.must_be_instance_of(Geometry::TwoPointLine)
	    line.first.must_equal Point[0,0]
	    line.last.must_equal Point[10,10]
	end

	it "must accept named start and end points" do
	    line = Line.new(start:Point[0,0], end:Point[10,10])
	    line.must_be_kind_of(Line)
	    line.must_be_instance_of(Geometry::TwoPointLine)
	    line.first.must_equal Point[0,0]
	    line.last.must_equal Point[10,10]
	end

	it "must raise an exception when no arguments are given" do
	    -> { Line.new }.must_raise ArgumentError
	end
    end

    it "create a Line object from 2 Points" do
	line = Geometry::Line[Geometry::Point[0,0], Geometry::Point[10,10]]
	assert_kind_of(Geometry::Line, line)
	assert_kind_of(Geometry::TwoPointLine, line)
    end
    it "create a Line object from two arrays" do
	line = Geometry::Line[[0,0], [10,10]]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::TwoPointLine, line)
	assert_kind_of(Geometry::Point, line.first)
	assert_kind_of(Geometry::Point, line.last)
    end
    it "create a Line object from two Vectors" do
	line = Geometry::Line[Vector[0,0], Vector[10,10]]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::TwoPointLine, line)
    end

    it "create a Line from a slope and y-intercept" do
	line = Geometry::Line[0.75, 5]
	assert(line.is_a?(Geometry::Line))
	assert_kind_of(Geometry::SlopeInterceptLine, line)
	assert_equal(5, line.intercept)
	assert_equal(0.75, line.slope)
    end

    it "create a Line from a Rational slope and y-intercept" do
	line = Geometry::Line[Rational(3,4), 5]
	assert_kind_of(Geometry::SlopeInterceptLine, line)
	assert(line.is_a?(Geometry::Line))
	assert_equal(Rational(3,4), line.slope)
    end

    it "have a special constructor for horizontal lines" do
	line = Geometry::Line.horizontal
	assert(line.horizontal?)
    end
    it "have a special constructor for vertical lines" do
	line = Geometry::Line.vertical
	assert(line.vertical?)
    end

    it "have accessor for y-intercept" do
	line = Geometry::Line[0.75, 5]
	assert_equal(5, line.intercept)
	assert_equal(5, line.intercept(:y))
    end
    it "have accessor for x-intercept" do
	line = Geometry::Line.vertical(7)
	assert_equal(7, line.intercept(:x))
    end

    it "return the correct x-intercept for vertical lines" do
	line = Geometry::Line.vertical(7)
	assert_equal(7, line.intercept(:x))
    end
    it "return the correct y-intercept for horizontal lines" do
	line = Geometry::Line.horizontal(4)
	assert_equal(4, line.intercept(:y))
    end

    it "return nil x-intercept for horizontal lines" do
	line = Geometry::Line.horizontal
	assert_nil(line.intercept(:x))
    end
    it "return nil y-intercept for vertical lines" do
	line = Geometry::Line.vertical
	assert_nil(line.intercept(:y))
    end

    it "implement inspect" do
	line = Geometry::Line[[0,0], [10,10]]
	assert_equal('Line(Point[0, 0], Point[10, 10])', line.inspect)
    end
    it "implement to_s" do
	line = Geometry::Line[[0,0], [10,10]]
	assert_equal('Line(Point[0, 0], Point[10, 10])', line.to_s)
    end
end
