require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'pawn'


class Board
  POSITION = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    set_board
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def dup
    copy = Board.new
    copy.grid = @grid.map do |row|
      row.map do |piece|
        (piece.nil?)? nil : piece.dup
      end
    end
    copy
  end

  def set_board
    [0, 7].each do |row|
      color = row == 0 ? :black : :white
      POSITION.each_with_index do |piece_class, col|
        self[[row, col]] = piece_class.new([row, col], color, self)
      end
    end

    [1, 6].each do |row|
      color = row == 1 ? :black : :white
      (0..7).each do |col|
        self[[row, col]] = Pawn.new([row, col], color, self)
      end
    end

  end

  def in_check?(color)
    king_position = find_king_position(color)
    checking_king?(king_position, color)
  end

  def checking_king?(king_position, color)
    # find opposite pieces
    # go through all their moves and see if they can get to king_position

    @grid.any? do |row|
      row.any? do |piece|
        piece && piece.moves.include?(king_position) && piece.color != color
      end
    end

  end

  def find_king_position(color)
    king = nil
    @grid.each do |row|
      row.each { |piece| king = piece if piece.class == King && piece.color == color }
    end
    king.pos
  end

  def show
    display_string = @grid.map do |row|
      row.map do |piece, index|
        if piece
          piece.render
        else
          "__"
        end
      end.join(" ")
    end
    puts display_string
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    raise "There's no piece at start position" unless piece
    raise "There's a piece in the way." unless piece.moves.include?(end_pos)

    unless piece.valid_moves.include?(end_pos)
      raise "Piece can't move there or your King will be in check."
    end

    self[end_pos] = piece
    piece.pos = end_pos

    self[start_pos] = nil

  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]

    self[end_pos] = piece
    piece.pos = end_pos

    self[start_pos] = nil
  end

  def checkmate?(piece_color)

    my_pieces = @grid.flatten.select do |piece|
        piece if piece && piece.color == piece_color
    end

    my_pieces.all? { |piece| piece.valid_moves.empty? }


  end


  def in_bound?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end

end

b = Board.new

b.show

b.move([6,5],[5,5])
b.move([1,4],[3,4])
b.move([6,6],[4,6])
b.move([0,3],[4,7])

b.show
p b.in_check?(:white)
p b.checkmate?(:white)
# b.move([6, 3], [4, 3])
# b.move([7, 3], [5, 3])
# b.move([5,3], [1,7])
# b.move([0,1], [2,2])
# b.move([2,2], [4,3])
# b.move([4,3], [2,4])
# b.move([1,3], [3,3])
# b.move([0,2], [1,3])
# b.move([1,3], [4,0])
# b.move([4,0], [6,2])
# b.move([6,2], [6,3])
# b[[7,3]] = b[[0,3]].dup
# p "======="
# b.show
#
# d = b.dup
# p "duped board ============"
# d.show
# p d[[7,4]].moves
# p d[[7,4]].valid_moves
# p "is white in check"
# p d.in_check?(:white)
# p d.checkmate?(:white)
#
# # p b[[7,4]].board[[7,3]].render
# #b.show
# #p b.checkmate?(:white)
# # b.move([7,4], [7,3])
# # p b[[7,4]].valid_moves
# # p b.in_check?(:white)








