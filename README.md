### Affine transformation fitting class

Given a set of origin and target points, returns an affine transformation matrix
that can be used to convert any point in the original space to the target space.

This can be used to e.g. position a bitmap map over another (like [here](http://polymaps.org/ex/transform.html)) even though the details wouldn't quite exactly match.

### Usage

#### Example 1: simple translation (horizontal movement of +3)

```coffeescript
coffee> require "./affine_transformation"
coffee> from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
coffee> to = [[1, 2], [2, 2], [1, 1], [2, 1]]
coffee> tr = new AffineTransformation(from, to)
coffee> tr.transform([-1.5, 1.5])
[ 1.5, 1.5 ]
coffee> tr.inversely_transform([1.5, 1.5])
[ -1.5, 1.5 ]
```

As you can see, the same transformation can also be used inversely. This
is useful when you need to find the original position of a point if
there is already an existing transformation.

#### Example 2: rotate + scale

```coffeescript
coffee> from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
coffee> to = [[1, -1], [-1, -1], [1, 1], [-1, 1]]
coffee> tr = new AffineTransformation(from, to)
coffee> tr.to_svg_transform()
'matrix(-2, 0, 0, -2, -3, 3)'
coffee> tr.transformation_matrix()
[ [ -2, 0, -3 ], [ 0, -2, 3 ] ]
```

Note how `to_svg_transform()` returns a string that you can drop straight into the [transform attribute](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) of an SVG element.

### License

The original implementation was done in [Python by Jarno Elonen](http://elonen.iki.fi/code/misc-notes/affine-fit/) and released into public
domain. In the same spirit I'll release this version under the [WTFPL](http://sam.zoy.org/wtfpl/). You can thus do what the fuck you want with. See LICENSE for more vulgarity.
