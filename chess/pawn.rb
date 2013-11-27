require_relative 'piece'

class Pawn < Piece
  BLACK_PAWN_DELTAS = [[1, -1], [1, 1], [1, 0], [2, 0]]
  WHITE_PAWN_DELTAS = [[-1, -1], [-1, 1], [-1, 0], [-2, 0]]

  def moves
    if @color == :white
      calc_moves(WHITE_PAWN_DELTAS)
    else
      calc_moves(BLACK_PAWN_DELTAS)
    end

  end

  def render
    PIECE_UNICODE[:pawn][@color].encode('utf-8')
  end

  private
  def calc_moves(deltas)
    valid_moves = []

    x, y = @pos

    # Attack moves
    deltas.take(2).each do |delta|
      coords = [x + delta[0], y + delta[1]]
      next unless @board.in_bound?(coords)
      next unless @board[coords] && @board[coords].color != @color
      valid_moves << coords
    end

    # Forward one-step valid_moves
    coords = [x + deltas[2][0], y + deltas[2][1]]
    valid_moves << coords unless @board[coords]

    # Forward two-step valid_moves
    if (@color == :white && x == 6) || (@color == :black && x == 1)
      coords = [x + deltas[3][0], y + deltas[3][1]]
      valid_moves << coords unless @board[coords]
    end

    valid_moves
  end

end
