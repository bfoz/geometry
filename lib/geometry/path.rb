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
	    raise(ArgumentError,'Unknown argument type') unless args.all? {|a| a.is_a?(Point) or a.is_a?(Edge) or a.is_a?(Arc) }

	    @elements = []

	    first = args.shift
	    @elements.push first if first.is_a?(Edge) or first.is_a?(Arc)

	    args.reduce(first) do |previous, n|
		case n
		    when Point
			case previous
			    when Point	    then @elements.push Edge.new(previous, n)
			    when Arc, Edge  then @elements.push Edge.new(previous.last, n) unless previous.last == n
			end
			@elements.last
		    when Edge
			case previous
			    when Point	    then @elements.push Edge.new(previous, n.first)
			    when Arc, Edge  then @elements.push Edge.new(previous.last, n.first) unless previous.last == n.first
			end
			@elements.push(n).last
		    when Arc
			case previous
			    when Point
				if previous == n.first
				    raise ArgumentError, "Duplicated point before an Arc"
				else
				    @elements.push Edge.new(previous, n.first)
				end
			    when Arc, Edge
				@elements.push Edge.new(previous.last, n.first) unless previous.last == n.first
			end
			@elements.push(n).last
		    else
			raise ArgumentError, "Unsupported argument type: #{n}"
		end
	    end
	end
    end
end
