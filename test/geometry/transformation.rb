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
	    it "must accept a y axis option" do
		t = Transformation.new :y => [1,0]
		t.rotation.y.must_equal [1,0]
		t.identity?.wont_equal true
	    end

	    it "must accept a rotation angle" do
		transformation = Transformation.new angle:90
		transformation.identity?.wont_equal true
		transformation.rotation.wont_be_nil
		transformation.rotation.angle.must_equal 90
	    end

	    it "must accept a rotation angle specified by an X-axis" do
		transformation = Transformation.new x:[0,1]
		rotation = transformation.rotation
		rotation.must_be_instance_of(RotationAngle)
		rotation.angle.must_equal Math::PI/2
		rotation.x.x.must_be_close_to 0
		rotation.x.y.must_be_close_to 1
		rotation.y.x.must_be_close_to -1
		rotation.y.y.must_be_close_to 0
	    end
	end
    end

    describe 'convenience constructors' do
	it 'must create a translation from coordinates' do
	    Geometry.translation(1, 2, 3).translation.must_equal Point[1,2,3]
	end

	it 'must create a translation from an Array' do
	    Geometry.translation([1, 2, 3]).translation.must_equal Point[1,2,3]
	end

	it 'must create a translation from a Point' do
	    Geometry.translation(Point[1, 2, 3]).translation.must_equal Point[1,2,3]
	end
    end

    it 'must translate with a Point' do
	Transformation.new(translate:[1,2]).translate(Point[3,4]).translation.must_equal Point[4,6]
    end

    it 'must translate with an Array' do
	Transformation.new(translate:[1,2]).translate([3,4]).translation.must_equal Point[4,6]
    end

    describe "comparison" do
	subject { Transformation.new(origin:[1,2]) }

	it "must equate equal transformations" do
	    subject.must_equal Transformation.new(origin:[1,2])
	end

	it "must not equal nil" do
	    subject.eql?(nil).wont_equal true
	end

	it "must not equate a translation with a rotation" do
	    subject.wont_equal Transformation.new(x:[0,1,0], y:[1,0,0])
	end

	it "must equate empty transformations" do
	    Transformation.new.must_equal Transformation.new
	end
    end

    describe "attributes" do
	describe "has_rotation?" do
	    it "must properly be true" do
		Transformation.new(angle:90).has_rotation?.must_equal true
	    end

	    it "must properly be false" do
		Transformation.new.has_rotation?.must_equal false
	    end
	end
    end

    describe "composition" do
	let(:translate_left) { Geometry::Transformation.new origin:[-2,-2] }
	let(:translate_right) { Geometry::Transformation.new origin:[1,1] }
	let(:transformation) { Geometry::Transformation.new }

	it "must add pure translation" do
	    (translate_left + translate_right).must_equal Geometry::Transformation.new origin:[-1,-1]
	end

	it "must add translation and no translation" do
	    (transformation + translate_left).must_equal translate_left
	    (translate_left + transformation).must_equal translate_left
	end

	it "array addition" do
	    (transformation + [1,2]).translation.must_equal Point[1,2]
	    ((transformation + [1,2]) + [2,3]).translation.must_equal Point[3,5]
	    (transformation + [1,2]).rotation.must_be_nil
	end

	it "must update the translation when an array is subtracted" do
	    (transformation - [1,2]).translation.must_equal Point[-1,-2]
	    ((transformation - [1,2]) - [2,3]).translation.must_equal Point[-3,-5]
	    (transformation - [1,2,3]).rotation.must_be_nil
	end

	it "must subtract translation and no translation" do
	    (transformation - translate_left).must_equal translate_left
	    (translate_left - transformation).must_equal translate_left
	end
    end

    describe "when transforming a Point" do
	describe "when no transformation is set" do
	    it "must return the Point" do
		Transformation.new.transform(Point[1,2]).must_equal Point[1,2];
	    end
	end

	it "must translate" do
	    Geometry::Transformation.new(origin:[0,1]).transform([1,0]).must_equal Point[1,1]
	end

	it "must rotate" do
	    rotated_point = Transformation.new(angle:Math::PI/2).transform([1,0])
	    rotated_point.x.must_be_close_to 0
	    rotated_point.y.must_be_close_to 1
	end

    end
end
