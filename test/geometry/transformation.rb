require 'minitest/autorun'
require 'geometry/point'
require 'geometry/transformation'

describe Geometry::Transformation do
    Transformation = Geometry::Transformation

    describe "when constructed" do
	it "must accept nothing and become an identity transformation" do
	    Transformation.new.identity?.must_equal true
	end

	it "must accept a translate parameter" do
	    Transformation.new([4,2]).translation.must_equal Point[4,2]
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

	it "must accept an origin option" do
	    translate = Transformation.new(:origin => [4,2])
	    translate.translation.must_equal Point[4,2]
	end

	it "must raise an exception when given too many translation options" do
	    lambda { Transformation.new :translate => [1,2], :origin => [3,4] }.must_raise ArgumentError
	end

	describe "when given a dimensions option" do
	    it "must raise an exception if the other arguments are too big" do
		lambda { Transformation.new :dimensions => 2, :origin => [1,2,3] }.must_raise ArgumentError
	    end

	    it "must raise an exception if the other arguments are too small" do
		lambda { Transformation.new :dimensions => 3, :origin => [1,2] }.must_raise ArgumentError
	    end

	    it "must not complain when given only a dimensions option" do
		Transformation.new(:dimensions => 3).dimensions.must_equal 3
	    end
	end

	describe "rotation" do
	    it "must accept an x axis option" do
		t = Transformation.new :x => [0,1]
		t.rotation.x.must_equal [0,1]
		t.identity?.wont_equal true
	    end

	    it "must accept a y axis option" do
		t = Transformation.new :y => [1,0]
		t.rotation.y.must_equal [1,0]
		t.identity?.wont_equal true
	    end
	end
    end

    describe "comparison" do
	it "must equate equal transformations" do
	    Transformation.new(origin:[1,2]).must_equal Transformation.new(origin:[1,2])
	end
    end

    describe "composition" do
	let(:transformation) { Geometry::Transformation.new }

	it "array addition" do
	    (transformation + [1,2]).translation.must_equal Point[1,2]
	    ((transformation + [1,2]) + [2,3]).translation.must_equal Point[3,5]
	    (transformation + [1,2]).rotation.identity?.must_equal true
	end

	it "must update the translation when an array is subtracted" do
	    (transformation - [1,2]).translation.must_equal Point[-1,-2]
	    ((transformation - [1,2]) - [2,3]).translation.must_equal Point[-3,-5]
	    (transformation - [1,2,3]).rotation.identity?.must_equal true
	end
    end
end
