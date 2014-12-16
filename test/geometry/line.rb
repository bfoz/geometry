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

describe Geometry::PointSlopeLine do
    subject { Geometry::PointSlopeLine.new [1,2], 3 }

    it "must have a slope attribute" do
	subject.slope.must_equal 3
    end

    it "must handle equality" do
	line2 = Geometry::PointSlopeLine.new([1,2], 3)
	line3 = Geometry::PointSlopeLine.new([1,1], 4)
	subject.must_equal line2
	subject.wont_equal line3
    end

    it 'must handle equality with a SlopeInterceptLine' do
	line2 = Geometry::SlopeInterceptLine.new(3, -1)
	line3 = Geometry::SlopeInterceptLine.new(4, -1)
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must handle equality with a TwoPointLine' do
	line2 = Geometry::TwoPointLine.new([1,2], [2,5])
	line3 = Geometry::TwoPointLine.new([1,2], [2,4])
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must know how to be horizontal' do
	Geometry::PointSlopeLine.new([1,2],0).horizontal?.must_equal true
	Geometry::PointSlopeLine.new([1,2],1).horizontal?.must_equal false
    end

    it 'must know how to be vertical' do
	Geometry::PointSlopeLine.new([1,2], Float::INFINITY).vertical?.must_equal true
	Geometry::PointSlopeLine.new([1,2], -Float::INFINITY).vertical?.must_equal true
	Geometry::PointSlopeLine.new([1,2],1).vertical?.must_equal false
    end

    it 'must have an x-intercept' do
	subject.intercept(:x).must_equal 1
    end

    it 'must not have an x-intercept for horizontal lines' do
	Geometry::PointSlopeLine.new([1,2], 0).intercept(:x).must_equal nil
    end

    it 'must have a y-intercept' do
	subject.intercept.must_equal -1
    end
end

describe Geometry::SlopeInterceptLine do
    subject { Geometry::SlopeInterceptLine.new 3, 2 }

    it "must have a slope attribute" do
	subject.slope.must_equal 3
    end

    it "must handle equality" do
	line2 = Geometry::SlopeInterceptLine.new(3, 2)
	line3 = Geometry::SlopeInterceptLine.new(4, 3)
	subject.must_equal line2
	subject.wont_equal line3
    end

    it 'must handle equality with a PointSlopeLine' do
	line2 = Geometry::PointSlopeLine.new([0,2], 3)
	line3 = Geometry::PointSlopeLine.new([0,2], 2)
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must handle equality with a TwoPointLine' do
	line2 = Geometry::TwoPointLine.new([0,2], [1,5])
	line3 = Geometry::TwoPointLine.new([0,2], [1,4])
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must know how to be horizontal' do
	Geometry::SlopeInterceptLine.new(0, 2).horizontal?.must_equal true
	Geometry::SlopeInterceptLine.new(1, 2).horizontal?.must_equal false
    end

    it 'must know how to be vertical' do
	Geometry::SlopeInterceptLine.new(Float::INFINITY, 2).vertical?.must_equal true
	Geometry::SlopeInterceptLine.new(-Float::INFINITY, 2).vertical?.must_equal true
	Geometry::SlopeInterceptLine.new(1, 2).vertical?.must_equal false
    end

    it 'must have an x-intercept' do
	subject.intercept(:x).must_equal -2/3
    end

    it 'must not have an x-intercept for horizontal lines' do
	Geometry::SlopeInterceptLine.new(0, 2).intercept(:x).must_equal nil
    end

    it 'must have a y-intercept' do
	subject.intercept.must_equal 2
    end
end

describe Geometry::TwoPointLine do
    subject { Geometry::TwoPointLine.new [1,2], [3,4] }

    it "must have a slope attribute" do
	subject.slope.must_equal 1
    end

    it "must handle equality" do
	line2 = Geometry::TwoPointLine.new([1,2], [3,4])
	line3 = Geometry::TwoPointLine.new([1,1], [5,5])
	subject.must_equal line2
	subject.wont_equal line3
    end

    it 'must handle equality with a PointSlopeLine' do
	line2 = Geometry::PointSlopeLine.new([1,2], 1)
	line3 = Geometry::PointSlopeLine.new([1,2], 2)
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must handle equality with a SlopeInterceptLine' do
	line2 = Geometry::SlopeInterceptLine.new(1, 1)
	line3 = Geometry::SlopeInterceptLine.new(1, -1)
	line2.must_equal subject
	line3.wont_equal subject
    end

    it 'must know how to be horizontal' do
	Geometry::TwoPointLine.new([1,2],[2,2]).horizontal?.must_equal true
	Geometry::TwoPointLine.new([1,2],[3,4]).horizontal?.must_equal false
    end

    it 'must know how to be vertical' do
	Geometry::TwoPointLine.new([1,2], [1,3]).vertical?.must_equal true
	Geometry::TwoPointLine.new([1,2], [1,-3]).vertical?.must_equal true
	Geometry::TwoPointLine.new([1,2],[3,4]).vertical?.must_equal false
    end

    it 'must have an x-intercept' do
	subject.intercept(:x).must_equal -1
    end

    it 'must not have an x-intercept for horizontal lines' do
	Geometry::TwoPointLine.new([1,2],[2,2]).intercept(:x).must_equal nil
    end

    it 'must have an x-intercept for vertical lines' do
	Geometry::TwoPointLine.new([1,2], [1,3]).intercept(:x).must_equal 1
    end

    it 'must have a y-intercept' do
	subject.intercept.must_equal 1
    end
end
