require_relative 'piece'

class SlidingPiece < Piece

  DIAGONAL_DELTAS = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
  CROSS_DELTAS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  def moves
    coords = []
    @directions.each do |direction|
      if direction == :diagonals
        coords += calc_moves(DIAGONAL_DELTAS)
      elsif direction == :cross
        coords += calc_moves(CROSS_DELTAS)
      end
    end

    coords
  end

  def calc_moves(deltas)
    moves = []

    deltas.each do |delta|
      x, y = @pos
      while true
        coords = [x + delta[0], y + delta[1]]
        break unless @board.in_bound?(coords)
        break if @board[coords] && @board[coords].color == @color

        moves << coords
        x += delta[0]
        y += delta[1]

        break if @board[coords] && @board[coords].color != @color
      end
    end

    moves
  end

  def move_dirs
    raise "Not Implemented"
  end

end


class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super
    @directions = [:diagonals]
  end

  def render
    PIECE_UNICODE[:bishop][@color].encode('utf-8')
  end
end


class Rook < SlidingPiece
  def initialize(pos, color, board)
    super
    @directions = [:cross]
  end

  def render
    PIECE_UNICODE[:rook][@color].encode('utf-8')
  end

end

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super
    @directions = [:cross, :diagonals]
  end

  def render

    PIECE_UNICODE[:queen][@color].encode('utf-8')
  end

end


# bish = Bishop.new([3, 3], :white, Board.new)
# rooky = Rook.new([3, 3], :white, Board.new)
# queeny = Queen.new([3, 3], :white, Board.new)
