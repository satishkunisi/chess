require_relative 'piece'

class SlidingPiece < Piece
  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def moves
    coords = []
    @directions.each do |direction|
      if direction == :diagonals
        coords += calc_diags
      elsif direction == :cross
        coords += calc_cross
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

  def calc_diags
    deltas = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
    calc_moves(deltas)
  end

  def calc_cross
    deltas = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    calc_moves(deltas)
  end

  def move_dirs
    raise "Not Implemented"
  end

end


class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
    @directions = [:diagonals]
  end

  def moves
    super
  end

end


class Rook < SlidingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
    @directions = [:cross]
  end

  def moves
    super
  end
end

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
    @directions = [:cross, :diagonals]
  end

  def moves
    super
  end
end


bish = Bishop.new([3, 3], :white, Board.new)
rooky = Rook.new([3, 3], :white, Board.new)
queeny = Queen.new([3, 3], :white, Board.new)
