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
        expect(@tr.transform([1569, 496545])).toEqual([1569, 496545])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([1.5, 1.5])).toEqual([1.5, 1.5])
        expect(@tr.inversely_transform([1569, 496545])).toEqual([1569, 496545])

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
        expect(@tr.transform([15, 4165])).toEqual([17, 4168])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([2.5, 1.5])).toEqual([0.5, -1.5])
        expect(@tr.inversely_transform([17, 4168])).toEqual([15, 4165])

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
        expect(@tr.transform([15690, -12345])).toEqual([15693, -12345])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([1.5, 1.5])).toEqual([-1.5, 1.5])
        expect(@tr.inversely_transform([15693, -12345])).toEqual([15690, -12345])

      it 'should not alter the original position', ->
        @tr.inversely_transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'transformation_matrix', ->
      it 'should return the correct matrix', ->
        expect(@tr.transformation_matrix()).toEqual([[1,0,3], [0,1,0]])

    describe 'to_svg_transform', ->
      it 'should return correct svg transform string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 3, 0)')

  describe 'simple translation with coplanar points', ->
    beforeEach ->
      @from = [[1, 1], [2, 2], [3, 3], [4, 4]]
      @to   = [[2, 2], [3, 3], [4, 4], [5, 5]]
      @tr = new AffineTransformation(@from, @to)

    describe 'transform', ->
      it 'should successfully translate points', ->
        expect(@tr.transform([1.5, 1.5])).toEqual([2.5, 2.5])
        expect(@tr.transform([2, 2])).toEqual([3, 3])
        expect(@tr.transform([4, 4])).toEqual([5, 5])
        expect(@tr.transform([1529, 4365])).toEqual([1530, 4366])

      it 'should not alter the original position', ->
        @tr.transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'inversely transform', ->
      it 'should successfully translate back to original points', ->
        expect(@tr.inversely_transform([1.5, 1.5])).toEqual([0.5, 0.5])

      it 'should not alter the original position', ->
        @tr.inversely_transform(@orig)
        expect(@orig).toEqual [1.5, 1.5]

    describe 'transformation_matrix', ->
      it 'should return the correct matrix', ->
        expect(@tr.transformation_matrix()).toEqual([[1,0,1], [0,1,1]])

    describe 'to_svg_transform', ->
      it 'should return correct svg transform string', ->
        expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 1, 1)')

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

  describe 'transform with only two points', ->
    describe 'translate', ->
      beforeEach ->
        @from = [[1, 1], [2, 2]]
        @to = [[2, 2], [3, 3]]
        @tr = new AffineTransformation(@from, @to)

      describe 'transform', ->
        it 'should successfully transform points', ->
          expect(@tr.transform([2, 2])).toEqual([3, 3])
          expect(@tr.transform([0, 0])).toEqual([1, 1])
          expect(@tr.transform([1, 1])).toEqual([2, 2])
          expect(@tr.transform([1529, 4365])).toEqual([1530, 4366])

      describe 'inversely transform', ->
        it 'should successfully translate back to original points', ->
          expect(@tr.inversely_transform([1.5, 1.5])).toEqual([0.5, 0.5])

        it 'should not alter the original position', ->
          @tr.inversely_transform(@orig)
          expect(@orig).toEqual [1.5, 1.5]

      describe 'transformation_matrix', ->
        it 'should return the correct matrix', ->
          expect(@tr.transformation_matrix()).toEqual([[1,0,1], [0,1,1]])

      describe 'to_svg_transform', ->
        it 'should return correct svg transform string', ->
          expect(@tr.to_svg_transform()).toEqual('matrix(1, 0, 0, 1, 1, 1)')

    describe 'translate + scale', ->
      beforeEach ->
        @from = [[0, 0], [1, 1]]
        @to = [[1, 1], [3, 3]]
        @tr = new AffineTransformation(@from, @to)

      describe 'transform', ->
        it 'should successfully transform points', ->
          expect(@tr.transform([2, 2])).toEqual([5, 5])
          expect(@tr.transform([0, 0])).toEqual([1, 1])
          expect(@tr.transform([1, 1])).toEqual([3, 3])

      describe 'inversely transform', ->
        it 'should successfully translate back to original points', ->
          expect(@tr.inversely_transform([5, 5])).toEqual([2, 2])

        it 'should not alter the original position', ->
          @tr.inversely_transform(@orig)
          expect(@orig).toEqual [1.5, 1.5]

      describe 'transformation_matrix', ->
        it 'should return the correct matrix', ->
          expect(@tr.transformation_matrix()).toEqual([[2,0,1], [0,2,1]])

      describe 'to_svg_transform', ->
        it 'should return correct svg transform string', ->
          expect(@tr.to_svg_transform()).toEqual('matrix(2, 0, 0, 2, 1, 1)')

    describe 'translate + scale + rotate', ->
      beforeEach ->
        @from = [[0,0], [1,1]]
        @to = [[2,2], [4,0]]
        @tr = new AffineTransformation(@from, @to)

      describe 'transform', ->
        it 'should successfully transform points', ->
          expect(@tr.transform([0, 0])).toEqual([2, 2])
          expect(@tr.transform([1, 1])).toEqual([4, 0])
          expect(@tr.transform([0.5, 0.5])).toEqual([3, 1])

      describe 'inversely transform', ->
        it 'should successfully translate back to original points', ->
          expect(@tr.inversely_transform([2, 2])).toEqual([0, 0])

        it 'should not alter the original position', ->
          @tr.inversely_transform(@orig)
          expect(@orig).toEqual [1.5, 1.5]

      describe 'transformation_matrix', ->
        it 'should return the correct matrix', ->
          expect(@tr.transformation_matrix()).toEqual([[0,2,2], [-2,0,2]])

      describe 'to_svg_transform', ->
        it 'should return correct svg transform string', ->
          expect(@tr.to_svg_transform()).toEqual('matrix(0, -2, 2, 0, 2, 2)')


