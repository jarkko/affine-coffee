### Affine transformation fitting class

Given a set of origin and target points, returns an affine transformation matrix
that can be used to convert any point in the original space to the target space.

This can be used to e.g. position a bitmap map over another (like [here](http://polymaps.org/ex/transform.html)) even though the details wouldn't quite exactly match.

### Usage

#### Example: simple translation (horizontal movement of +3)

```coffeescript
coffee> require "./affine_transformation"
coffee> from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
coffee> to = [[1, 2], [2, 2], [1, 1], [2, 1]]
coffee> tr = new AffineTransformation(from, to)
coffee> tr.transform([-1.5, 1.5])
[ 1.4999999999999996, 1.5000000000000002 ]
```

Yeah, gotta add rounding there...

### License

The original implementation was done in [Python by Jarno Elonen](http://elonen.iki.fi/code/misc-notes/affine-fit/) and released into public
domain. In the same spirit I'll release this version under the [WTFPL](http://sam.zoy.org/wtfpl/). You can thus do what the fuck you want with. See LICENSE for more vulgarity.