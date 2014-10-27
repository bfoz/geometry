require 'mathn'

require_relative 'point'

module Geometry

=begin rdoc
An edge. It's a line segment between 2 points. Generally part of a {Polygon}.

== Usage
    edge = Geometry::Edge.new([1,1], [2,2])
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

	# @param [Point] point	A {Point} to spaceship with
	# @return [Boolean]	Returns 1 if the {Point} is strictly to the left of the receiver, -1 to the right, and 0 if the point is on the receiver
	def <=>(point)
	    case point
		when Point
		    k = (@last.x - @first.x) * (point.y - @first.y) - (point.x - @first.x) * (@last.y - @first.y)
		    if 0 == k
			(((@first.x <=> point.x) + (@last.x <=> point.x)).abs <= 1) && (((@first.y <=> point.y) + (@last.y <=> point.y)).abs <= 1) ? 0 : nil
		    else
			k <=> 0
		    end
		else
		    raise ArgumentError, "Can't spaceship with #{point.class}"
	    end
	end

	# Return a new {Edge} with swapped endpoints
	def reverse
	    self.class.new(@last, @first)
	end

	# In-place swap the endpoints
	def reverse!
	    @first, @last = @last, @first
	    self
	end

	# @return [Number]  the length of the {Edge}
	def length
	    @length ||= vector.magnitude
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
	    v1 = self.direction
	    v2 = edge.direction
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

	# @param [Edge] other	The other {Edge} to check
	# @return [Bool] Returns true if the receiver and the passed {Edge} share an endpoint
	def connected?(other)
	    (@first == other.last) || (@last == other.first) || (@first == other.first) || (@last == other.last)
	end

	# @!attribute [r] direction
	# @return [Vector]  A unit {Vector} pointing from first to last
	def direction
	    @direction ||= self.vector.normalize
	end

	# Find the intersection of two {Edge}s (http://bloggingmath.wordpress.com/2009/05/29/line-segment-intersection/)
	# @param [Edge] other	The other {Edge}
	# @return [Point] The intersection of the two {Edge}s, nil if they don't intersect, true if they're collinear and overlapping, and false if they're collinear and non-overlapping
	def intersection(other)
	    return self.first if (self.first == other.first) or (self.first == other.last)
	    return self.last if (self.last == other.first) or (self.last == other.last)

	    p0, p1 = self.first, self.last
	    p2, p3 = other.first, other.last
	    v1, v2 = self.vector, other.vector

	    denominator = v1[0] * v2[1] - v2[0] * v1[1]		# v1 x v2
	    p = p0 - p2
	    if denominator == 0	    # collinear, so check for overlap
		if 0 == (-v1[1] * p.x + v1[0] * p.y)	# collinear?
		    # The edges are collinear, but do they overlap?
		    # Project them onto the x and y axes to find out
		    left1, right1 = [self.first[0], self.last[0]].sort
		    bottom1, top1 = [self.first[1], self.last[1]].sort
		    left2, right2 = [other.first[0], other.last[0]].sort
		    bottom2, top2 = [other.first[1], other.last[1]].sort

		    !((left2 > right1) || (right2 < left1) || (top2 < bottom1) || (bottom2 > top1))
		else
		    nil
		end
	    else
		s = (-v1[1] * p.x + v1[0] * p.y) / denominator	# v1 x (p0 - p2) / denominator
		t = ( v2[0] * p.y - v2[1] * p.x) / denominator	# v2 x (p0 - p2) / denominator

		p0 + v1 * t if ((0..1) === s) && ((0..1) === t)
	    end
	end

	# @!attribute [r] vector
	# @return [Vector]  A {Vector} pointing from first to last
	def vector
	    @vector ||= last - first
	end

	def to_a
	    [@first, @last]
	end
    end

    # Convenience initializer for {Edge} that tries to coerce its arguments into
    #  something useful
    # @param first	[Point, Array]	the starting point of the {Edge}
    # @param last	[Point, Array]	the endpoint of the {Edge}
    def Edge(first, last)
	Edge.new(first, last)
    end
end
