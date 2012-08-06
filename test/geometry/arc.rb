require 'minitest/autorun'
require 'geometry/arc'

describe Geometry::Arc do
    it "must create an Arc object from a Point and a radius" do
	arc = Geometry::Arc.new [1,2], 3, 0, 90
	arc.must_be_kind_of Geometry::Arc
	arc.center.must_equal Point[1,2]
	arc.radius.must_equal 3
	arc.start_angle.must_equal 0
	arc.end_angle.must_equal 90
    end
end
