require 'minitest/autorun'
require 'geometry/arc'

describe Geometry::Arc do
    Arc = Geometry::Arc

    describe "when constructed" do
	it "must accept a center point, radius, start and end angles" do
	    arc = Geometry::Arc.new center:[1,2], radius:3, start:0, end:90
	    arc.must_be_kind_of Geometry::Arc
	    arc.center.must_equal Point[1,2]
	    arc.radius.must_equal 3
	    arc.start_angle.must_equal 0
	    arc.end_angle.must_equal 90
	end

	it "must create an Arc from center, start and end points" do
	    arc = Geometry::Arc.new center:[1,2], start:[3,4], end:[5,6]
	    arc.must_be_kind_of Geometry::Arc
	    arc.center.must_equal Point[1,2]
	    arc.first.must_equal Point[3,4]
	    arc.last.must_equal Point[5,6]
	end
    end
end

describe Geometry::ThreePointArc do
    it 'must have an ending angle' do
	arc = Geometry::ThreePointArc.new([0,0], [1,0], [0,1])
	arc.end_angle.must_equal Math::PI/2
    end

    it 'must have a radius' do
	arc = Geometry::ThreePointArc.new([0,0], [1,0], [0,1])
	arc.radius.must_equal 1
    end

    it 'must have an starting angle' do
	arc = Geometry::ThreePointArc.new([0,0], [1,0], [0,1])
	arc.start_angle.must_equal 0
    end

    describe 'max' do
	# Cosine and sine of a 22.5 degree angle
	let(:cos) { 0.9239556995 }
	let(:sin) { 0.3824994973 }
	let(:radius) { 1.0000000000366434 }

	it 'must handle an Arc entirely in quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [sin,cos])
	    arc.max.must_equal Point[cos,cos]
	end

	it 'must handle a counterclockwise Arc from quadrant 1 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [-cos,sin])
	    arc.max.must_equal Point[cos,radius]
	end

	it 'must handle a counterclockwise Arc from quadrant 4 to quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [sin,-cos], [sin,cos])
	    arc.max.must_equal Point[radius,cos]
	end

	it 'must handle a counterclockwise Arc from quadrant 3 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [-cos,-sin], [-cos,sin])
	    arc.max.must_equal Point[radius,radius]
	end
    end

    describe 'min' do
	# Cosine and sine of a 22.5 degree angle
	let(:cos) { 0.9239556995 }
	let(:sin) { 0.3824994973 }
	let(:radius) { 1.0000000000366434 }

	it 'must handle an Arc entirely in quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [sin,cos])
	    arc.min.must_equal Point[sin,sin]
	end

	it 'must handle a counterclockwise Arc from quadrant 1 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [-cos,sin])
	    arc.min.must_equal Point[-cos,sin]
	end

	it 'must handle a counterclockwise Arc from quadrant 4 to quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [sin,-cos], [sin,cos])
	    arc.min.must_equal Point[sin,-cos]
	end

	it 'must handle a counterclockwise Arc from quadrant 3 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [-cos,-sin], [-cos,sin])
	    arc.min.must_equal Point[-cos,-radius]
	end
    end

    describe 'minmax' do
	# Cosine and sine of a 22.5 degree angle
	let(:cos) { 0.9239556995 }
	let(:sin) { 0.3824994973 }
	let(:radius) { 1.0000000000366434 }

	it 'must handle an Arc entirely in quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [sin,cos])
	    arc.minmax.must_equal [Point[sin,sin], Point[cos,cos]]
	end

	it 'must handle a counterclockwise Arc from quadrant 1 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [cos,sin], [-cos,sin])
	    arc.minmax.must_equal [Point[-cos,sin], Point[cos,radius]]
	end

	it 'must handle a counterclockwise Arc from quadrant 4 to quadrant 1' do
	    arc = Geometry::ThreePointArc.new([0,0], [sin,-cos], [sin,cos])
	    arc.minmax.must_equal [Point[sin,-cos], Point[radius,cos]]
	end

	it 'must handle a counterclockwise Arc from quadrant 3 to quadrant 2' do
	    arc = Geometry::ThreePointArc.new([0,0], [-cos,-sin], [-cos,sin])
	    arc.minmax.must_equal [Point[-cos,-radius], Point[radius,radius]]
	end
    end
end