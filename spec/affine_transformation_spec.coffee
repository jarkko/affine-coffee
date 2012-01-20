require '../vendor/sylvester/sylvester.src'
require '../affine_transformation'

describe 'New AffineTransformation', ->
  beforeEach ->
    @orig = [1.5, 1.5]

  describe 'when from and to are of different size', ->
    beforeEach ->
      @from = [[1,1], [2,2], [3,3]]
      @to = [[1,2], [1,2]]

    it 'should throw an exception', ->
      expect(=> new AffineTransformation(@from, @to)).toThrow('Both from and to must be of same size')

  describe 'when to and from are empty', ->
    beforeEach ->
      @from = @to = []
      @tr = new AffineTransformation(@from, @to)

    describe 'transformation_matrix', ->
      it 'should return a no-op matrix', ->
        expect(@tr.transformation_matrix()).toEqual([[1,0,0], [0,1,0]])

    describe 'to_svg_transform', ->
      it 'should return correct transformation string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 0, 0)')

    describe 'transform', ->
      it 'should successfully translate points to themselves', ->
        expect(@tr.transform([1.5, 1.5])).toEqual([1.5, 1.5])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([1.5, 1.5])).toEqual([1.5, 1.5])

      it 'should not alter the original position', ->
        @tr.inversely_transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

  describe 'when there is only one correction', ->
    beforeEach ->
      @from = [[1,2]]
      @to = [[3,5]]
      @tr = new AffineTransformation(@from, @to)

    describe 'transformation_matrix', ->
      it 'should return a simple translating matrix', ->
        expect(@tr.transformation_matrix()).toEqual([[1,0,2], [0,1,3]])

    describe 'to_svg_transform', ->
      it 'should return correct transformation string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 2, 3)')

    describe 'transform', ->
      it 'should successfully translate points', ->
        expect(@tr.transform([1.5, 1.5])).toEqual([3.5, 4.5])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([2.5, 1.5])).toEqual([0.5, -1.5])

      it 'should not alter the original position', ->
        @tr.inversely_transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

  describe 'simple translation (movement)', ->
    beforeEach ->
      @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
      @to   = [[1, 2], [2, 2], [1, 1], [2, 1]]
      @tr = new AffineTransformation(@from, @to)

    describe 'transform', ->
      it 'should successfully translate points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([1.5, 1.5])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([1.5, 1.5])).toEqual([-1.5, 1.5])

      it 'should not alter the original position', ->
        @tr.inversely_transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

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
      it 'should successfully transform points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([-0.5, 0.5])

    describe 'inversely transform', ->
      it 'should successfully transform back to original points', ->
        expect(@tr.inversely_transform([-0.5, 0.5])).toEqual([-1.5, 1.5])

    describe 'to_svg_transform', ->
      it 'should return correct svg transform string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(-1, 0, 0, -1, -2, 2)')

  describe 'simple rotation + scaling', ->
    beforeEach ->
      @from = [[-2, 2], [-1, 2], [-2, 1], [-1, 1]]
      @to = [[1, -1], [-1, -1], [1, 1], [-1, 1]]
      @tr = new AffineTransformation(@from, @to)

    describe 'transform', ->
      it 'should successfully transform points', ->
        expect(@tr.transform([-1.5, 1.5])).toEqual([0.0, 0.0])

    describe 'inversely transform', ->
      it 'should successfully transform back to original points', ->
        expect(@tr.inversely_transform([0, 0])).toEqual([-1.5, 1.5])

    describe 'to_svg_transform', ->
      it 'should return correct svg transform string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(-2, 0, 0, -2, -3, 3)')
