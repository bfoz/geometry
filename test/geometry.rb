require 'minitest/autorun'
require 'geometry'

describe Geometry do
    it "create a Point object" do
	point = Geometry.point(2,1)
	assert_kind_of(Geometry::Point, point)
    end

    it "create a Line object" do
	line = Geometry.line([0,0], [10,10])
	assert_kind_of(Geometry::Line, line)
	assert_kind_of(Geometry::TwoPointLine, line)
    end
end
