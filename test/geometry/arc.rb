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
