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

	# @return [Geometry]	The last element in the {Path}
	def last
	    @elements.last
	end

	# Append a new geometry element to the {Path}
	# @return [Path]
	def push(arg)
	    @elements.push arg
	    self
	end
    end
end
