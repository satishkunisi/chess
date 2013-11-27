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
    valid_coords = []
    moves.each do |move_coord|

      duped_board = @board.dup
      duped_board.move!(@pos, move_coord)

      # duped_board.show

      next if duped_board.in_check?(@color)
      valid_coords << move_coord
    end
    valid_coords
  end



end


