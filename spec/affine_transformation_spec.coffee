require '../affine_transformation'

describe 'New AffineTransformation', ->
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

  describe 'transform', ->
    describe 'simple translation (movement)', ->
      beforeEach ->
        @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
        @to   = [[1, 2], [2, 2], [1, 1], [2, 1]]
        @tr = new AffineTransformation(@from, @to)

      it 'should successfully translate points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([1.5, 1.5])
    describe 'simple rotation', ->
      beforeEach ->
        @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
        @to = [[0,0], [-1,0], [0,1], [-1,1]]
        @tr = new AffineTransformation(@from, @to)

      it 'should successfully translate points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([-0.5, 0.5])

    describe 'simple rotation + scaling', ->
      beforeEach ->
        @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
        @to = [[1, -1], [-1, -1], [1, 1], [-1, 1]]
        @tr = new AffineTransformation(@from, @to)

      it 'should successfully translate points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([0.0, 0.0])