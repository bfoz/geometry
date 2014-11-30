require 'minitest/autorun'
require 'geometry/annulus'

describe Geometry::Annulus do
    it 'must complain when constructed with only a center' do
	-> { Geometry::Annulus.new center:Point[1,2] }.must_raise ArgumentError
    end

    it 'must also be known as a Ring' do
	Geometry::Ring.new(Point[1,2], inner_radius:5, radius:10).must_be_instance_of Geometry::Annulus
    end
    
    describe 'when constructed with a named center' do
	subject { Geometry::Annulus.new center:Point[1,2], inner_radius:5, radius:10 }

	it 'must have a center' do
	    subject.center.must_equal Point[1,2]
	end

	it 'must have a max' do
	    subject.max.must_equal Point[11, 12]
	end

	it 'must have a min' do
	    subject.min.must_equal Point[-9, -8]
	end

	it 'must have a min and a max' do
	    subject.minmax.must_equal [subject.min, subject.max]
	end
    end
    
    describe 'when constructed with a center, inner_radius and radius' do
	subject { Geometry::Annulus.new Point[1,2], inner_radius:5, radius:10 }

	it 'must have a center' do
	    subject.center.must_equal Point[1,2]
	end

	it 'must have an inner diameter' do
	    subject.inner_diameter.must_equal 10
	end

	it 'must have an inner radius' do
	    subject.inner_radius.must_equal 5
	end

	it 'must have an outer diameter' do
	    subject.outer_diameter.must_equal 20
	end

	it 'must have a radius' do
	    subject.radius.must_equal 10
	    subject.outer_radius.must_equal 10
	end
    end

    describe 'when constructed with a center, inner_diameter and diameter' do
	subject { Geometry::Annulus.new Point[1,2], inner_diameter:5, diameter:10 }

	it 'must have a center' do
	    subject.center.must_equal Point[1,2]
	end

	it 'must have an inner diameter' do
	    subject.inner_diameter.must_equal 5
	end

	it 'must have an inner radius' do
	    subject.inner_radius.must_equal 2.5
	end

	it 'must have an outer diameter' do
	    subject.outer_diameter.must_equal 10
	end

	it 'must have a radius' do
	    subject.radius.must_equal 5
	end
    end
end
