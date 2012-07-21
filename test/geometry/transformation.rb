require 'minitest/autorun'
require 'geometry/point'
require 'geometry/transformation'

describe Geometry::Transformation do
    Point = Geometry::Point
    Transformation = Geometry::Transformation

    let(:transformation) { Geometry::Transformation.new }

    describe "when constructed" do
	it "must accept nothing and become and identity transformation" do
	    Transformation.new.identity?.must_equal true
	end

	it "must accept a translate Array" do
	    translate = Transformation.new(:translate => [4,2])
	    translate.translation.must_equal Point[4,2]
	end

	it "must accept a translate Point" do
	    translate = Transformation.new(:translate => Point[4,2])
	    translate.translation.must_equal Point[4,2]
	end

	it "must accept a translate Point equal to zero" do
	    translate = Transformation.new(:translate => [0,0])
	    translate.translation.must_equal nil
	end

	it "must accept a translate Vector" do
	    translate = Transformation.new(:translate => Vector[4,2])
	    translate.translation.must_equal Point[4,2]
	end
    end
end
