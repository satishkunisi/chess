class Piece
  attr_accessor :pos, :color
  attr_reader :board

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def moves
    raise "Not Implemented"
  end

  def valid_moves
    moves.delete_if do |move_coord|
      duped_board = @board.dup
      duped_board.move(@pos, move_coord)
      duped_board.in_check?(@color)
    end
    moves
  end
end



