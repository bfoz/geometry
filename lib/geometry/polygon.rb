require_relative 'edge'

module Geometry

=begin rdoc
An object representing a closed set of vertices and edges.

{http://en.wikipedia.org/wiki/Polygon}

== Usage

=end

    class Polygon
	attr_reader :edges, :vertices
	alias :points :vertices

	# Construct a new Polygon from Points and/or Edges
	#  The constructor will try to convert all of its arguments into Points and
	#   Edges. Then successive Points will be collpased into Edges. Successive
	#   Edges that share a common vertex will be added to the new Polygon. If
	#   there's a gap between Edges it will be automatically filled with a new
	#   Edge. The resulting Polygon will then be closed if it isn't already.
	# @overload new(Array, Array, ...)
	#   @return [Polygon]
	# @overload new(Edge, Edge, ...)
	#   @return [Polygon]
	# @overload new(Point, Point, ...)
	#   @return [Polygon]
	# @overload new(Vector, Vector, ...)
	#   @return [Polygon]
	def initialize(*args)
	    args.map! {|a| (a.is_a?(Array) || a.is_a?(Vector)) ? Point[a] : a}
	    raise(ArgumentError,'Unknown argument type') unless args.all? {|a| a.is_a?(Point) || a.is_a?(Edge) }

	    @edges = [];
	    @vertices = [];

	    first = args.shift
	    if first.is_a?(Point)
		@vertices.push first
	    elsif first.is_a?(Edge)
		@edges.push first
		@vertices.push *(first.to_a)
	    end

	    args.reduce(@vertices.last) do |previous,n|
		if n.is_a?(Point)
		    push_edge Edge.new(previous, n)
		    push_vertex n
		    n
		elsif n.is_a?(Edge)
		    if previous == n.first
			push_edge n
			push_vertex n.last
		    elsif previous == n.last
			push_edge n.reverse!
			push_vertex n.last
		    else
			e = Edge.new(previous, n.first)
			push_edge e, n
			push_vertex *(e.to_a), *(n.to_a)
		    end
		    n.last
		end
	    end

	    # Close the polygon if needed
	    @edges.push Edge.new(@edges.last.last, @edges.first.first) unless @edges.empty? || (@edges.last.last == @edges.first.first)
	end

	private

	def push_edge(*e)
	    @edges.push *e
	    @edges.uniq!
	end
	def push_vertex(*v)
	    @vertices.push *v
	    @vertices.uniq!
	end
    end
end
