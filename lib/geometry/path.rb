require 'geometry/arc'
require 'geometry/edge'

module Geometry
=begin
An object representing a set of connected elements, each of which could be an
{Edge} or an {Arc}. Unlike a {Polygon}, a {Path} is not guaranteed to be closed.
=end
    class Path
	attr_reader :elements

	# Construct a new Path from {Point}s, {Edge}s, and {Arc}s
	#  Successive {Point}s will be converted to {Edge}s.
	def initialize(*args)
	    args.map! {|a| (a.is_a?(Array) or a.is_a?(Vector)) ? Point[a] : a}
	    args.each {|a| raise ArgumentError, "Unknown argument type #{a.class}" unless a.is_a?(Point) or a.is_a?(Edge) or a.is_a?(Arc) }

	    @elements = []

	    first = args.shift
	    push first if first.is_a?(Edge) or first.is_a?(Arc)

	    args.reduce(first) do |previous, n|
		case n
		    when Point
			case previous
			    when Point	    then push Edge.new(previous, n)
			    when Arc, Edge  then push Edge.new(previous.last, n) unless previous.last == n
			end
			last
		    when Edge
			case previous
			    when Point	    then push Edge.new(previous, n.first)
			    when Arc, Edge  then push Edge.new(previous.last, n.first) unless previous.last == n.first
			end
			push(n).last
		    when Arc
			case previous
			    when Point
				if previous == n.first
				    raise ArgumentError, "Duplicated point before an Arc"
				else
				    push Edge.new(previous, n.first)
				end
			    when Arc, Edge
				push Edge.new(previous.last, n.first) unless previous.last == n.first
			end
			push(n).last
		    else
			raise ArgumentError, "Unsupported argument type: #{n}"
		end
	    end
	end

	def ==(other)
	    if other.is_a?(Path)
		@elements == other.elements
	    else
		super other
	    end
	end

    # @group Attributes

	# @return [Point]   The upper-right corner of the bounding rectangle that encloses the {Path}
	def max
	    elements.reduce(elements.first.max) {|memo, e| memo.max(e.max) }
	end

	# @return [Point]   The lower-left corner of the bounding rectangle that encloses the {Path}
	def min
	    elements.reduce(elements.first.min) {|memo, e| memo.min(e.max) }
	end

	# @return [Array<Point>]    The lower-left and upper-right corners of the enclosing bounding rectangle
	def minmax
	    elements.reduce(elements.first.minmax) {|memo, e| [memo.first.min(e.min), memo.last.max(e.max)] }
	end

	# @return [Geometry]	The last element in the {Path}
	def last
	    @elements.last
	end

    # @endgroup

	# Append a new geometry element to the {Path}
	# @return [Path]
	def push(arg)
	    @elements.push arg
	    self
	end
    end
end
