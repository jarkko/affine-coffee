# 'private' helper method
round_to_precision = (num, precision = 10) ->
  Math.round(num * Math.pow(10,precision)) / Math.pow(10,precision)

class AffineTransformation
  constructor: (@from, @to) ->
    if @from.length isnt @to.length || @from.length < 1
      throw 'Both from and to must be of same size'

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
    res = []
    for j in [0...@dim]
      res[j] = []
      for i in [0...@dim]
        res[j].push(round_to_precision(@m[i][j + @dim + 1]))
      res[j].push(round_to_precision(@m[@dim][j + @dim + 1]))
    res

  to_svg_transform: ->
    res = []
    for i in [0..@dim]
      for j in [0...@dim]
        res.push(@transformation_matrix()[j][i])

    "matrix(#{res.join(', ')})"

  transform: (pt) ->
    res = (0.0 for a in [0...@dim])
    for j in [0...@dim]
      for i in [0...@dim]
        res[j] += pt[i] * @m[i][j + @dim + 1]
      res[j] += @m[@dim][j + @dim + 1]
    res

(global ? window).AffineTransformation = AffineTransformation