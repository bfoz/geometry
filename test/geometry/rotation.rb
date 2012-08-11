require 'minitest/autorun'
require 'geometry/rotation'

describe Geometry::Rotation do
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
end
