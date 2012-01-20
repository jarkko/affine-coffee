require './vendor/sylvester/sylvester.src'

# 'private' helper method
round_to_precision = (num, precision = 10) ->
  Math.round(num * Math.pow(10,precision)) / Math.pow(10,precision)

class AffineTransformation
  constructor: (@from, @to) ->
    if @from.length isnt @to.length
      throw 'Both from and to must be of same size'

    if @from.length is 0
      @buildNoOpMatrix()
      return

    if @from.length is 1
      @buildTranslationMatrix()
      return

    if @to.length < (@dim = @to[0].length)
      throw 'Too few points => under-determined system'

    c = ((0.0 for a in [0...@dim]) for i in [0..@dim])
    for j in [0...@dim]
      for k in [0..@dim]
        for i in [0...(@from.length)]
          qt = @from[i].concat [1]
          c[k][j] += qt[k] * @to[i][j]

    q = ((0.0 for a in [0...@dim]).concat([0]) for i in [0..@dim])
    for qi in @from
      qt = qi.concat [1]
      for i in [0..@dim]
        for j in [0..@dim]
          q[i][j] += qt[i] * qt[j]

    @m = (q[i].concat(c[i]) for i in [0..@dim])
    if !@gauss_jordan(@m)
      throw "Singular matrix. Points are probably coplanar."


  gauss_jordan: (m, eps = 1.0/Math.pow(10,10)) ->
    [h, w] = [m.length, m[0].length]
    for y in [0...h]
      maxrow = y
      for y2 in [(y+1)...h]
        maxrow = y2 if Math.abs(m[y2][y]) > Math.abs(m[maxrow][y])

      [m[y], m[maxrow]] = [m[maxrow], m[y]]

      return false if Math.abs(m[y][y]) <= eps # Singular?

      for y2 in [(y + 1)...h]
        c = m[y2][y] / m[y][y]
        for x in [y...w]
          m[y2][x] -= m[y][x] * c

    for y in [(h - 1)..0] # Backsubstitute
      c = m[y][y]
      for y2 in [0...y]
        for x in [(w - 1)..y]
          m[y2][x] -= m[y][x] * m[y2][y] / c
      m[y][y] /= c
      for x in [h...w] # Normalize row y
        m[y][x] /= c

    true

  to_string: ->
    res = ''
    for j in [0...@dim]
      str = "x#{j}"
      for i in [0...@dim]
        str += "x#{i} * #{@m[i][j + @dim + 1]}"
      str += "#{@m[@dim][j + @dim + 1]}"
      res += str + "\n"
    res

  transformation_matrix: ->
    return @matrix if @matrix

    @matrix = []
    for j in [0...@dim]
      @matrix[j] = []
      for i in [0...@dim]
        @matrix[j].push(round_to_precision(@m[i][j + @dim + 1]))
      @matrix[j].push(round_to_precision(@m[@dim][j + @dim + 1]))
    @matrix

  buildNoOpMatrix: ->
    @matrix = [[1,0,0], [0,1,0]]

  buildTranslationMatrix: ->
    @matrix = [[1, 0, (@to[0][0] - @from[0][0])],
               [0, 1, (@to[0][1] - @from[0][1])]]

  transformation_matrix_m: ->
    $M(@transformation_matrix())

  inverse_transformation_matrix: ->
    arr = (el for el in @transformation_matrix_m().elements)
    arr.push([0, 0, 1])
    $M(arr).inverse()

  to_svg_transform: ->
    res = []
    for i in [0..@dim]
      for j in [0...@dim]
        res.push(@transformation_matrix()[j][i])

    "matrix(#{res.join(', ')})"

  transform: (pt) ->
    @_transform_with_matrix(pt, @transformation_matrix_m())

  inversely_transform: (pt) ->
    @_transform_with_matrix(pt, @inverse_transformation_matrix())

  _transform_with_matrix: (pt, matrix) ->
    pt = pt.slice(0,2)
    pt.push(1)
    orig = $M([i] for i in pt)
    res = matrix.x(orig)
    (i[0] for i in res.elements)[0..1]

(global ? window).AffineTransformation = AffineTransformation
