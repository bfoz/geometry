require 'minitest/autorun'
require 'geometry/obround'

describe Geometry::Obround do
    Obround = Geometry::Obround

    describe "when constructed" do
	it "must accept two Points" do
	    obround = Geometry::Obround.new [1,2], [3,4]
	    obround.must_be_kind_of Geometry::Obround
	end

	it "must accept a width and height" do
	    obround = Geometry::Obround.new 2, 3
	    obround.must_be_kind_of Geometry::Obround
	    obround.height.must_equal 3
	    obround.width.must_equal 2
	end

	it "must compare equal" do
	    obround = Geometry::Obround.new [1,2], [3,4]
	    obround.must_equal Obround.new([1,2], [3,4])
	end
    end

    it 'must always be closed' do
	obround = Geometry::Obround.new 2, 3
	obround.closed?.must_equal true
    end
end
