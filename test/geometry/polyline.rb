require 'minitest/autorun'
require 'geometry/polyline'

describe Geometry::Polyline do
    Polyline = Geometry::Polyline

    let(:closed_unit_square) { Polyline.new [0,0], [1,0], [1,1], [0,1], [0,0] }
    let(:unit_square) { Polyline.new [0,0], [1,0], [1,1], [0,1] }
    let(:reverse_unit_square)	{ Polyline.new [0,1], [1,1], [1,0], [0,0] }

    it "must create a Polyline object with no arguments" do
	polyline = Geometry::Polyline.new
	polyline.must_be_kind_of Polyline
	polyline.edges.count.must_equal 0
	polyline.vertices.count.must_equal 0
    end

    it "must create a Polyline object from array arguments" do
	polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	polyline.must_be_kind_of Polyline
	polyline.edges.count.must_equal 3
	polyline.vertices.count.must_equal 4
    end

    it 'must have a points attribute' do
	unit_square.points.must_equal [Point[0,0], Point[1,0], Point[1,1], Point[0,1]]
    end

    it 'must know the max' do
	unit_square.max.must_equal Point[1,1]
    end

    it 'must know the min' do
	unit_square.min.must_equal Point[0,0]
    end

    it 'must know the min and the max' do
	unit_square.minmax.must_equal [Point[0,0], Point[1,1]]
    end

    it 'must close when the first and last edges are collinear' do
	polygon = Polyline.new([1,0], [2,0], [2,1], [-1,1], [-1,0], [0,0]).close!
	polygon.must_equal Polyline.new([-1,0], [2,0], [2,1], [-1,1])
    end

    it 'must close when the closing edge is collinear with the last edge' do
	polygon = Polyline.new([1,0], [1,1], [-1,1], [-1,0], [0,0]).close!
	polygon.must_equal Polyline.new([1,0], [1,1], [-1,1], [-1,0], [1,0])
    end

    it 'must close when the closing edge is collinear with the first edge' do
	polygon = Polyline.new([0,0], [1,0], [1,1], [-1,1], [-1, 0]).close!
	polygon.must_equal Polyline.new([-1,0], [1,0], [1,1], [-1,1], [-1,0])
    end

    it 'must close when the closing edge backtracks over the first edge' do
	polygon = Polyline.new([0,0], [2,0], [2,1], [-1,1], [-1, -1], [1,-1], [1,0]).close!
	polygon.must_equal Polyline.new([1,0], [2,0], [2,1], [-1,1], [-1,-1], [1,-1])

	polygon = Polyline.new([0,-1], [0,1], [1,1], [1,0], [0,0]).close!
	polygon.must_equal Polyline.new([0,0], [0,1], [1,1], [1,0], [0,0])
    end

    it 'must close when already closed and the first and last edges are collinear' do
	polygon = Polyline.new([1,0], [1,1], [0,1], [0,-1], [1,-1], [1,0]).close!
	polygon.must_equal Polyline.new([1,-1], [1,1], [0,1], [0,-1])
    end

    it 'must close when the closing edge exactly backtracks the last edge' do
	polygon = Polyline.new([0,0], [0,1], [1,1], [1,0], [0,0], [0,1]).close!
	polygon.must_equal Polyline.new([0,0], [0,1], [1,1], [1,0], [0,0])
    end

    describe "when the Polyline is closed" do
	let(:closed_concave_polyline) { Polyline.new [-2,0], [0,0], [0,-2], [2,-2], [2,2], [-2,2], [-2,0] }
	subject { closed_concave_polyline }

	it "must be closed" do
	    closed_unit_square.closed?.must_equal true
	end

	it "must clone and close" do
	    closed = subject.close
	    closed.closed?.must_equal true
	    closed.must_equal subject
	    closed.wont_be_same_as subject
	end

	it "must be able to close itself" do
	    subject.close!
	    subject.closed?.must_equal true
	    subject.must_equal subject
	end

	it "must clone and reverse" do
	    vertices = subject.vertices
	    vertices.push vertices.shift
	    reversed = subject.reverse
	    reversed.vertices.must_equal vertices.reverse
	    reversed.wont_be_same_as subject
	    reversed.closed?.must_equal true
	end

	it "must reverse itself" do
	    original = subject.vertices.dup
	    subject.reverse!
	    subject.vertices.to_a.must_equal original.reverse
	    subject.closed?.must_equal true
	end

	it "must generate bisectors" do
	    closed_unit_square.bisectors.must_equal [Vector[1, 1], Vector[-1, 1], Vector[-1, -1], Vector[1, -1]]
	end

	it "must generate bisectors with an inside corner" do
	    closed_concave_polyline.bisectors.must_equal [Vector[1,1], Vector[-1,-1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[1,-1]]
	end

	it "must generate left bisectors" do
	    closed_unit_square.left_bisectors.must_equal [Vector[1, 1], Vector[-1, 1], Vector[-1, -1], Vector[1, -1]]
	end

	it "must generate left bisectors with an inside corner" do
	    closed_concave_polyline.left_bisectors.must_equal [Vector[1,1], Vector[1,1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[1,-1]]
	end

	it "must generate right bisectors" do
	    closed_unit_square.right_bisectors.must_equal [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
	end

	it "must generate right bisectors with an inside corner" do
	    closed_concave_polyline.right_bisectors.must_equal [Vector[-1,-1], Vector[-1,-1], Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
	end

	it "must generate spokes" do
	    closed_unit_square.spokes.must_equal [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
	end

	it "must rightset a closed concave polyline where the first outset edge intersects with the last outset edge" do
	    skip
	    polyline = Polyline.new [0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0], [0,0]
	    polyline.offset(-1).must_equal Polyline.new [1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2]
	end
    end

    describe "when the Polyline is open" do
	let(:concave_polyline) { Polyline.new [-2,0], [0,0], [0,-2], [2,-2], [2,2], [-2,2] }
	subject { concave_polyline }

	it "must not be closed" do
	    unit_square.closed?.must_equal false
	end

	it "must clone and close" do
	    closed = subject.close
	    closed.closed?.must_equal true
	    closed.must_equal subject
	    closed.wont_be_same_as subject
	end

	it "must be able to close it" do
	    closed = subject.close!
	    closed.closed?.must_equal true
	    closed.must_equal subject
	    closed.must_be_same_as subject
	end

	it "must clone and reverse" do
	    reversed = subject.reverse
	    reversed.vertices.must_equal subject.vertices.reverse
	    reversed.wont_be_same_as subject
	    reversed.closed?.wont_equal true
	end

	it "must reverse itself" do
	    original = subject.vertices.dup
	    subject.reverse!
	    subject.vertices.to_a.must_equal original.reverse
	    subject.closed?.wont_equal true
	end

	it "must generate bisectors" do
	    unit_square.bisectors.must_equal [Vector[0, 1], Vector[-1, 1], Vector[-1, -1], Vector[0, -1]]
	end

	it "must generate bisectors with an inside corner" do
	    concave_polyline.bisectors.must_equal [Vector[0,1], Vector[-1,-1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[0,-1]]
	end

	it "must generate left bisectors" do
	    unit_square.left_bisectors.must_equal [Vector[0, 1], Vector[-1, 1], Vector[-1, -1], Vector[0, -1]]
	    reverse_unit_square.left_bisectors.must_equal [Vector[0, 1], Vector[1, 1], Vector[1, -1], Vector[0, -1]]
	end

	it "must generate right bisectors" do
	    unit_square.right_bisectors.must_equal [Vector[0,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
	end

	it "must generate right bisectors with an inside corner" do
	    concave_polyline.right_bisectors.must_equal [Vector[0,-1], Vector[-1,-1], Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
	end

	it "must generate left bisectors with an inside corner" do
	    concave_polyline.left_bisectors.must_equal [Vector[0,1], Vector[1,1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[0,-1]]
	end

	it "must generate spokes" do
	    unit_square.spokes.must_equal [Vector[0,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
	end
    end

    describe "when checking for closedness" do
	it "must be closed when it is closed" do
	    closed_unit_square.closed?.must_equal true
	end

	it "must not be closed when it is not closed" do
	    unit_square.closed?.must_equal false
	end
    end

    describe "when creating a Polyline from an array of Points" do
	it "must ignore repeated Points" do
	    polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [1,1], [0,1])
	    polyline.must_be_kind_of Geometry::Polyline
	    polyline.must_equal Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse collinear Edges" do
	    polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0.5,1], [0,1])
	    polyline.must_equal Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
	end

	it "must collapse backtracking Edges" do
	    polyline = Geometry::Polyline.new [0,0], [2,0], [2,2], [1,2], [1,1], [1,2], [0,2]
	    polyline.must_equal Geometry::Polyline.new([0,0], [2,0], [2,2], [0,2])
	end
    end

    it "must compare identical polylines as equal" do
	(unit_square.eql? unit_square).must_equal true
    end

    it "must rightset a closed concave polyline where the first outset edge intersects with the last outset edge" do
	skip
	polyline = Polyline.new [0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0], [0,0]
	polyline.offset(-1).must_equal Polyline.new [1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2]
    end

    describe "when offsetting" do
	describe "with a positive offset" do
	    it "must leftset a unit square" do
		expected_polyline = Polyline.new [0,0.1], [0.9,0.1], [0.9,0.9], [0,0.9]
		unit_square.offset(0.1).must_equal expected_polyline
	    end

	    it "must leftset a simple concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,4], [3,4], [3,3], [1,3], [1,4], [0,4]
		offset_polyline = concave_polyline.offset(1)
		offset_polyline.must_equal Polyline.new [0,1], [3,1], [3,2], [0,2], [0,3]
	    end
	end

	describe "with a negative offset" do
	    it "must rightset a unit square" do
		expected_polyline = Polyline.new [0,-1.0], [2.0,-1.0], [2.0,2.0], [0,2.0]
		unit_square.offset(-1).must_equal expected_polyline
	    end

	    it "must rightset a simple concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-1)
		offset_polyline.must_equal Polyline.new [0,-1], [5,-1], [5,3], [0,3]
	    end

	    it "must rightset a concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [6,-2], [6,4], [0,4]
	    end

	    it "must rightset an asymetric concave polyline" do
		concave_polyline = Polyline.new [0,0], [4,0], [4,3], [3,3], [3,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [6,-2], [6,5], [1,5], [1,4], [0,4]
	    end

	    it "must rightset a concave polyline with multiply-intersecting edges" do
		concave_polyline = Polyline.new [0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [0,-2], [7,-2], [7,4], [0,4]
	    end

	    it "must rightset a closed concave polyline with multiply-intersecting edges" do
		concave_polyline = Polyline.new [0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2], [0,0]
		offset_polyline = concave_polyline.offset(-2)
		offset_polyline.must_equal Polyline.new [-2,-2], [7,-2], [7,4], [-2,4]
	    end

	    it "must rightset a concave polyline where the first outset edge intersects with the last outset edge" do
		polyline = Polyline.new [0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0]
		polyline.offset(-1).must_equal Polyline.new [1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2]
	    end

	    # Naturally, this test is very sensitive to the input coordinate values. This is a painfully contrived example that
	    #  checks for sensitivity to edges that are very close to horizontal, but not quite.
	    # When the test fails, the first point of the offset polyline is at [0,-1]
	    it "must not be sensitive to floating point rounding errors" do
		polyline = Polyline.new [0, 0], [0, -2], [10, -2], [10, 10], [-100, 10], [-100, -22], [-69, -22], [-69, 3.552713678800501e-15], [0,0]
		outset = polyline.offset(-1)
		outset.edges.first.first.must_equal Geometry::Point[-1,-1]
	    end
	end
    end
end
