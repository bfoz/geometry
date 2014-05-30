require 'minitest/autorun'
require 'geometry/rotation'

describe Geometry::Rotation do
    Point = Geometry::Point
    Rotation = Geometry::Rotation
    RotationAngle = Geometry::RotationAngle

    describe "when constructed" do
	it "must accept a rotation angle" do
	    rotation = Rotation.new angle:Math::PI/2
	    rotation.must_be_instance_of(RotationAngle)
	    rotation.angle.must_equal Math::PI/2
	    rotation.x.x.must_be_close_to 0
	    rotation.x.y.must_be_close_to 1
	    rotation.y.x.must_be_close_to -1
	    rotation.y.y.must_be_close_to 0
	end

	it "must accept an X axis" do
	    rotation = Rotation.new x:[1,0]
	    rotation.must_be_instance_of(RotationAngle)
	    rotation.angle.must_equal 0
	    rotation.x.must_equal Point[1,0]
	    rotation.y.must_equal Point[0,1]
	end
    end

    it "must accept x and y axes" do
	rotation = Geometry::Rotation.new :x => [1,2,3], :y => [4,5,6]
	rotation.x.must_equal [1,2,3]
	rotation.y.must_equal [4,5,6]
    end

    it "must accept 3-element x and y axes and a dimensionality of 3" do
	rotation = Geometry::Rotation.new(:dimensions => 3, :x => [1,2,3], :y => [4,5,6])
	rotation.dimensions.must_equal 3
    end

    it "must reject 3-element x and y axes and a dimensionality of 2" do
	lambda { Geometry::Rotation.new(:dimensions => 2, :x => [1,2,3], :y => [4,5,6]) }.must_raise ArgumentError
    end

    it "must promote 2-element Vectors to dimensionality of 3" do
	rotation = Geometry::Rotation.new(:dimensions => 3, :x => [1,2], :y => [4,5])
	rotation.dimensions.must_equal 3
	rotation.x.must_equal [1,2,0]
	rotation.y.must_equal [4,5,0]
    end

    it "must be the identity rotation if no axes are given" do
	Geometry::Rotation.new.identity?.must_equal true
	Geometry::Rotation.new(:dimensions => 3).identity?.must_equal true
    end

    it "must be the identity rotation when identity axes are given" do
	Geometry::Rotation.new(:x => [1,0,0], :y => [0,1,0])
    end

    it "must have a matrix accessor" do
	r = Geometry::Rotation.new(:x => [1,0,0], :y => [0,1,0])
	r.matrix.must_equal Matrix[[1,0,0],[0,1,0],[0,0,1]]
    end

    describe "when comparing" do
	it "must equate equal objects" do
	    Rotation.new(x:[1,2,3], y:[4,5,6]).must_equal Rotation.new(x:[1,2,3], y:[4,5,6])
	end
    end

    describe "comparison" do
	it "must equate equal angles" do
	    Rotation.new(angle:45).must_equal Rotation.new(angle:45)
	end

	it "must not equate unequal angles" do
	    Rotation.new(angle:10).wont_equal Rotation.new(angle:45)
	end
    end

    describe "composition" do
	it "must add angles" do
	    (Rotation.new(angle:45) + Rotation.new(angle:45)).must_equal Rotation.new(angle:90)
	end

	it "must subtract angles" do
	    (Rotation.new(angle:45) - Rotation.new(angle:45)).must_equal Rotation.new(angle:0)
	end

	it "must negate angles" do
	    (-Rotation.new(angle:45)).must_equal Rotation.new(angle:-45)
	end
    end

    describe "when transforming a Point" do
	subject { Rotation.new(angle:Math::PI/2) }

	describe "when no rotation is set" do
	    it "must return the Point" do
		Rotation.new.transform(Point[1,0]).must_equal Point[1,0]
	    end
	end

	it "must rotate" do
	    rotated_point = Rotation.new(angle:Math::PI/2).transform(Point[1,0])
	    rotated_point.x.must_be_close_to 0
	    rotated_point.y.must_be_close_to 1
	end

	it 'must transform a PointZero' do
	    subject.transform(Point.zero).must_equal Point.zero
	end
    end
end
