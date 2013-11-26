class Piece
  attr_accessor :pos, :color
  attr_reader :board

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def moves
    raise "Not Implemented"
  end

end



