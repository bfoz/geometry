require 'minitest/autorun'
require 'geometry/regular_polygon'

describe Geometry::RegularPolygon do
    RegularPolygon = Geometry::RegularPolygon

    describe "when constructed with named center and radius arguments" do
	let(:polygon) { RegularPolygon.new sides:4, center:[1,2], radius:3 }

	it "must create a RegularPolygon" do
	    polygon.must_be_instance_of(RegularPolygon)
	end

	it "must have the correct number of sides" do
	    polygon.edge_count.must_equal 4
	end

	it "must have a center point accessor" do
	    polygon.center.must_equal Point[1,2]
	end

	it "must have a radius accessor" do
	    polygon.radius.must_equal 3
	end

	it "must compare equal" do
	    polygon.must_equal RegularPolygon.new(sides:4, center:[1,2], radius:3)
	end
    end

    describe "when constructed with a center and diameter" do
	let(:polygon) { RegularPolygon.new sides:4, center:[1,2], diameter:4 }

	it "must be a DiameterRegularPolygon" do
	    polygon.must_be_instance_of(Geometry::DiameterRegularPolygon)
	    polygon.must_be_kind_of(RegularPolygon)
	end

	it "must have the correct number of sides" do
	    polygon.edge_count.must_equal 4
	end

	it "must have a center" do
	    polygon.center.must_equal Point[1,2]
	end

	it "must have a diameter" do
	    polygon.diameter.must_equal 4
	end

	it "must calculate the correct radius" do
	    polygon.radius.must_equal 2
	end

	it "must compare equal" do
	    polygon.must_equal RegularPolygon.new(sides:4, center:[1,2], diameter:4)
	end
    end

    describe "when constructed with a diameter and no center" do
	let(:polygon) { RegularPolygon.new sides:4, diameter:4 }

	it "must be a DiameterRegularPolygon" do
	    polygon.must_be_instance_of(Geometry::DiameterRegularPolygon)
	    polygon.must_be_kind_of(RegularPolygon)
	end

	it "must have the correct number of sides" do
	    polygon.edge_count.must_equal 4
	end

	it "must have a nil center" do
	    polygon.center.must_be_nil
	end

	it "must have a diameter" do
	    polygon.diameter.must_equal 4
	end

	it "must calculate the correct radius" do
	    polygon.radius.must_equal 2
	end
    end
end
