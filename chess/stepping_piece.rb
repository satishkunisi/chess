require_relative 'piece'
require 'colorize'

class SteppingPiece < Piece
  KNIGHT_DELTAS = [[-2, 1], [-1, 2], [1, 2], [2, 1],
              [2, -1], [1, -2], [-1, -2], [-2, -1]]

  KING_DELTAS = [[-1, 1], [0, 1], [1, 1], [1, 0],
              [1, -1], [0, -1], [-1, -1]]

  def moves
    if @directions == :knight
      calc_moves(KNIGHT_DELTAS)
    elsif @directions == :king
      calc_moves(KING_DELTAS)
    end
  end

  private
  def calc_moves(deltas)
    valid_moves = []
    x, y = @pos
    deltas.each do |delta|
      coords = [x + delta[0], y + delta[1]]

      next unless @board.in_bound?(coords)
      next if @board[coords] && @board[coords].color == @color
      valid_moves << coords
    end

    valid_moves
  end

end


class Knight < SteppingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
    @directions = :knight
  end

  def render
    PIECE_UNICODE[:knight][@color].encode('utf-8')
  end

end


class King < SteppingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
    @directions = :king
  end

  def render
    PIECE_UNICODE[:king][@color].encode('utf-8')
  end

end