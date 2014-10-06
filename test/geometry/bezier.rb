require 'minitest/autorun'
require 'geometry/bezier'

describe Geometry::Bezier do
    subject { Geometry::Bezier.new [0,0], [1,1], [2,2], [3,3] }

    it 'must have control points' do
	subject.points.length.must_equal 4
    end

    it 'must generate Pascals Triangle' do
	subject.binomial_coefficient(0).must_equal 1
	subject.binomial_coefficient(1).must_equal 3
	subject.binomial_coefficient(2).must_equal 3
	subject.binomial_coefficient(3).must_equal 1
    end

    it 'must return nil when t is out of range' do
	subject[2].must_equal nil
    end

    it 'must subscript on the parameter' do
	subject[0.5].must_equal Point[1.5, 1.5]
    end
end
