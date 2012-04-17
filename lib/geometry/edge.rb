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
	    @first, @last = [point0, point1].map {|p| p.is_a?(Point) ? p : Point[p] }
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

	def to_a
	    [@first, @last]
	end
    end
end
