require_relative 'point'

module Geometry

=begin rdoc
An edge. It's a line segment between 2 points. Generally part of a {Polygon}.

== Usage
    edge = Geometry::Edge([1,1], [2,2])

=end

    class Edge
	attr_reader :first, :last

	# Construct a new {Edge} object from any two things that can be converted
	# to a {Point}.
	def initialize(point0, point1)
	    @first, @last = [Point[point0], Point[point1]]
	end

	# Two Edges are equal if both have equal {Point}s in the same order
	def ==(other)
	    (@first == other.first) && (@last == other.last)
	end

	# Return a new {Edge} with swapped endpoints
	def reverse
	    Edge.new(@last, @first)
	end

	# In-place swap the endpoints
	def reverse!
	    @first, @last = @last, @first
	    self
	end

	# Return the {Edge}'s length along the Y axis
	def height
	    (@first.y - @last.y).abs
	end

	# Return the {Edge}'s length along the X axis
	def width
	    (@first.x - @last.x).abs
	end

	def inspect
	    'Edge(' + @first.inspect + ', ' + @last.inspect + ')'
	end
	alias :to_s :inspect

	# @return [Bool] Returns true if the passed {Edge} is parallel to the receiver
	def parallel?(edge)
	    v1, v2 = self.direction, edge.direction
	    winding = v1[0]*v2[1] - v1[1]*v2[0]
	    if 0 == winding	# collinear?
		if v1 == v2
		    1		# same direction
		else
		    -1		# opposite direction
		end
	    else
		false
	    end
	end

	# @return [Vector]  A unit {Vector} pointing from first to last
	def direction
	    self.vector.normalize
	end

	# @return [Vector]  A {Vector} pointing from first to last
	def vector
	    Vector[*((last-first).to_a)]
	end

	def to_a
	    [@first, @last]
	end
    end
end
