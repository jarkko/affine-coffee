require '../affine_transformation'

describe 'New AffineTransformation', ->
  beforeEach ->
    @addMatchers {
      toNearlyEqual: (expected, precision = 10) ->
        actual = ((Math.round(i * Math.pow(10,precision)) / Math.pow(10,precision)) for i in this.actual)
        parseFloat(actual) == parseFloat(expected)
    }
  describe 'when from and to are of different size', ->
    beforeEach ->
      @from = [[1,1], [2,2], [3,3]]
      @to = [[1,2], [1,2]]


    it 'should throw an exception', ->
      expect(=> new AffineTransformation(@from, @to)).toThrow('Both from and to must be of same size')

  describe 'when to and from are empty', ->
    beforeEach ->
      @from = @to = []

    it 'should throw an exception', ->
      expect(=> new AffineTransformation(@from, @to)).toThrow('Both from and to must be of same size')

  describe 'when there are more dimensions than fixed points', ->
    beforeEach ->
      @from = @to = [[1,2]]

    it 'should throw an exception', ->
      expect(=> new AffineTransformation(@from, @to)).toThrow('Too few points => under-determined system')

  describe 'simple translation (movement)', ->
    beforeEach ->
      @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
      @to   = [[1, 2], [2, 2], [1, 1], [2, 1]]
      @tr = new AffineTransformation(@from, @to)

    describe 'transform', ->
      it 'should successfully translate points', ->
        expect(@tr.transform([-1.5, 1.5])).toNearlyEqual([1.5, 1.5])

    describe 'transformation_matrix', ->
      it 'should return the correct matrix', ->
        expect(@tr.transformation_matrix()).toEqual([[1,0,3], [0,1,0]])

    describe 'to_svg_transform', ->
      it 'should return correct svg transform string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 3, 0)')

    describe 'simple rotation', ->
      beforeEach ->
        @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
        @to = [[0,0], [-1,0], [0,1], [-1,1]]
        @tr = new AffineTransformation(@from, @to)

      describe 'transform', ->
        it 'should successfully translate points', ->
          expect(@tr.transform([-1.5, 1.5])).toNearlyEqual([-0.5, 0.5])

    describe 'simple rotation + scaling', ->
      beforeEach ->
        @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
        @to = [[1, -1], [-1, -1], [1, 1], [-1, 1]]
        @tr = new AffineTransformation(@from, @to)

      describe 'transform', ->
        it 'should successfully translate points', ->
          expect(@tr.transform([-1.5, 1.5])).toNearlyEqual([0.0, 0.0])