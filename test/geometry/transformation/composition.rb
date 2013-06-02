require 'minitest/autorun'
require 'geometry/transformation/composition'

describe Geometry::Transformation::Composition do
    Composition = Geometry::Transformation::Composition
    Transformation = Geometry::Transformation

    subject { Composition.new }

    describe "when constructed" do
	it "must accept multiple transformations" do
	    composition = Composition.new(Transformation.new, Transformation.new)
	    composition.size.must_equal 2
	end

	it "must reject anything that isn't a Transformation" do
	    -> { Composition.new :foo }.must_raise TypeError
	end
    end

    describe "attributes" do
	describe "has_rotation?" do
	    it "must properly be true" do
		Composition.new(Transformation.new angle:90).has_rotation?.must_equal true
	    end

	    it "must properly be false" do
		subject.has_rotation?.must_equal false
	    end
	end
    end

    describe "when composing" do
	it "must append a Transformation" do
	    (Composition.new(Transformation.new) + Transformation.new).size.must_equal 2
	end

	it "must merge with a Composition" do
	    (Composition.new(Transformation.new) + Composition.new(Transformation.new)).size.must_equal 2
	end
    end

    describe "when transforming a Point" do
	it "must handle composed translations" do
	    composition = Composition.new(Transformation.new origin:[1,2]) + Composition.new(Transformation.new [3,4])
	    composition.transform(Point[5,6]).must_equal Point[9, 12]
	end
    end
end
