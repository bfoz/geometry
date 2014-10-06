Geometry for Ruby
=================

[![Build Status](https://travis-ci.org/bfoz/geometry.png)](https://travis-ci.org/bfoz/geometry)
[![Gem Version](https://badge.fury.io/rb/geometry.svg)](http://badge.fury.io/rb/geometry)

Classes and methods for the handling of all of the basic geometry that you 
learned in high school (and then forgot).

The classes in this libary are based on the Vector class provided by the Ruby 
standard library. Geometric primitives are generally assumed to lie in 2D space,
but aren't necessarily restricted to it. Please let me know if you find cases 
that don't work in higher dimensions and I'll do my best to fix them.

License
-------

Copyright 2012-2014 Brandon Fosdick <bfoz@bfoz.net> and released under the BSD license.

Primitives
----------

- Point
- Size
- Line
- Edge
- [Annulus](http://en.wikipedia.org/wiki/Annulus_(mathematics))
- [Arc](http://en.wikipedia.org/wiki/Arc_(geometry)), Circle
- [Bézier Curves](http://en.wikipedia.org/wiki/Bézier_curve)
- Rectangle, Square
- Path, [Polyline](http://en.wikipedia.org/wiki/Polyline), [Polygon](http://en.wikipedia.org/wiki/Polygon), [RegularPolygon](http://en.wikipedia.org/wiki/Regular_polygon)
- Transformation
- [Triangle](http://en.wikipedia.org/wiki/Triangle)
- [Obround](http://en.wiktionary.org/wiki/obround)

Examples
--------

### Point
```ruby
point = Geometry::Point[3,4]    # 2D Point at coordinate 3, 4

# Copy constructors
point2 = Geometry::Point[point]
point2 = Geometry::Point[Vector[5,6]]

# Accessors
point.x
point.y
point[2]	# Same as point.z

# Zero
PointZero.new   # A Point full of zeros of unspecified length
Point.zero      # Another way to do the same thing
Point.zero(3)   # => Point[0,0,0]
```

### Line
```ruby
# Two-point constructors
line = Geometry::Line[[0,0], [10,10]]
line = Geometry::Line[Geometry::Point[0,0], Geometry::Point[10,10]]
line = Geometry::Line[Vector[0,0], Vector[10,10]]

# Slope-intercept constructors
Geometry::Line[Rational(3,4), 5]	# Slope = 3/4, Intercept = 5
Geometry::Line[0.75, 5]

# Point-slope constructors
Geometry::Line(Geometry::Point[0,0], 0.75)
Geometry::Line(Vector[0,0], Rational(3,4))

# Special constructors (2D only)
Geometry::Line.horizontal(y=0)
Geometry::Line.vertical(x=0)
```

### Rectangle
```ruby
# A Rectangle made from two corner points
Geometry::Rectangle.new [1,2], [2,3]
Geometry::Rectangle.new from:[1,2], to:[2,3]

Geometry::Rectangle.new center:[1,2], size:[1,1]	# Using a center point and a size
Geometry::Rectangle.new origin:[1,2], size:[1,1]	# Using an origin point and a size

# A Rectangle with its origin at [0, 0] and a size of [10, 20]
Geometry::Rectangle.new size: [10, 20]
Geometry::Rectangle.new size: Size[10, 20]
Geometry::Rectangle.new width: 10, height: 20
```

### Circle
```ruby
# A circle at Point[1,2] with a radius of 3
circle = Geometry::Circle.new center:[1,2], radius:3
```

### Polygon
```ruby
# A polygon that looks a lot like a square
polygon = Geometry::Polygon.new [0,0], [1,0], [1,1], [0,1]
```
### Regular Polygon
```ruby
# Everyone loves a good hexagon
hexagon = Geometry::RegularPolygon.new 6, :diameter => 3
```

### Zeros and Ones
```ruby
# For when you know you need a zero, but you don't know how big it should be
zero = Point.zero       # Returns a Point of indeterminate length that always compares equal to zero

# Oh, you wanted ones instead? No problem.
ones = Point.one        # => Point[1,1,1...1]

# Looking for something more exotic that a mere 1?
iso = Point.iso(5)      # => Point[5,5,5...5]
```
