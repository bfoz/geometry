require 'minitest/autorun'
require 'geometry/regular_polygon'

describe Geometry::RegularPolygon do
    RegularPolygon = Geometry::RegularPolygon

    subject { RegularPolygon.new sides:4, center:[1,2], radius:3 }

    it 'must always be closed' do
	subject.closed?.must_equal true
    end

    describe 'when constructed with a center and circumradius' do
	let(:polygon) { RegularPolygon.new sides:4, center:[1,2], radius:3 }
	subject { RegularPolygon.new sides:4, center:[1,2], radius:3 }

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

	describe "properties" do
	    it "must have vertices" do
		subject.vertices.must_equal [Point[4.0, 2.0], Point[1.0000000000000002, 5.0], Point[-2.0, 2.0000000000000004], Point[0.9999999999999994, -1.0]]
	    end
	end

	it 'must have an indiameter' do
	    subject.indiameter.must_be_close_to 4.242
	end

	it 'must have an inradius' do
	    subject.inradius.must_be_close_to 2.121
	end
    end

    describe "when constructed with a center and diameter" do
	let(:polygon) { RegularPolygon.new sides:4, center:[1,2], diameter:4 }

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

	it "must have the correct number of sides" do
	    polygon.edge_count.must_equal 4
	end

	it "must be at the origin" do
	    polygon.center.must_equal Point.zero
	end

	it "must have a diameter" do
	    polygon.diameter.must_equal 4
	end

	it "must calculate the correct radius" do
	    polygon.radius.must_equal 2
	end
    end

    describe 'when constructed with an indiameter and center' do
	subject { RegularPolygon.new sides:6, indiameter:4 }

	it 'must have a circumdiameter' do
	    subject.diameter.must_be_close_to 4.618
	end

	it 'must have a circumradius' do
	    subject.circumradius.must_be_close_to 2.309
	end

	it 'must have an indiameter' do
	    subject.indiameter.must_be_close_to 4
	end

	it 'must have an inradius' do
	    subject.inradius.must_be_close_to 2
	end
    end

    describe 'when constructed with an inradius and center' do
	subject { RegularPolygon.new sides:6, inradius:4 }

	it 'must have a circumradius' do
	    subject.circumradius.must_be_close_to 4.618
	end

	it 'must have points' do
	    expected_points = [Point[4.618, 0], Point[2.309, 4], Point[-2.309, 4], Point[-4.618, 0], Point[-2.309, -4], Point[2.309, -4]]
	    subject.points.zip(expected_points) do |point0, point1|
		point0.to_a.zip(point1.to_a) {|a, b| a.must_be_close_to b }
	    end
	end
    end

    describe "properties" do
	subject { RegularPolygon.new sides:6, diameter:4 }

	it "must have edges" do
	    expected_edges = [Edge(Point[2, 0], Point[1, 1.732]), Edge(Point[1, 1.732], Point[-1, 1.732]), Edge(Point[-1, 1.732], Point[-2, 0]), Edge(Point[-2, 0], Point[-1, -1.732]), Edge(Point[-1, -1.732], Point[1, -1.732]), Edge(Point[1, -1.732], Point[2, 0])]
	    subject.edges.zip(expected_edges) do |edge1, edge2|
		edge1.to_a.zip(edge2.to_a) do |point1, point2|
		    point1.to_a.zip(point2.to_a) {|a, b| a.must_be_close_to b }
		end
	    end
	end

	it 'must have points' do
	    expected_points = [Point[2, 0], Point[1, 1.732], Point[-1, 1.732], Point[-2, 0], Point[-1, -1.732], Point[1, -1.732]]
	    subject.points.zip(expected_points) do |point0, point1|
		point0.to_a.zip(point1.to_a) {|a, b| a.must_be_close_to b }
	    end
	end

	it "must have a bounds property that returns a Rectangle" do
	    subject.bounds.must_equal Rectangle.new([-2,-2], [2,2])
	end

	it "must have a minmax property that returns the corners of the bounding rectangle" do
	    subject.minmax.must_equal [Point[-2,-2], Point[2,2]]
	end

	it "must have a max property that returns the upper right corner of the bounding rectangle" do
	    subject.max.must_equal Point[2,2]
	end

	it "must have a min property that returns the lower left corner of the bounding rectangle" do
	    subject.min.must_equal Point[-2,-2]
	end
    end
end
