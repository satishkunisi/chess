class Piece
  attr_accessor :pos, :color
  attr_reader :board

  PIECE_UNICODE = { :king =>   { :white => "\u2654", :black => "\u265a"},
                    :queen =>  { :white => "\u2655", :black => "\u265b"},
                    :rook =>   { :white => "\u2656", :black => "\u265c"},
                    :bishop => { :white => "\u2657", :black => "\u265d"},
                    :knight => { :white => "\u2658", :black => "\u265e"},
                    :pawn =>   { :white => "\u2659", :black => "\u265f"} }

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

      next if duped_board.in_check?(@color)
      valid_coords << move_coord
    end

    valid_coords
  end

end

