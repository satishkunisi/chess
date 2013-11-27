require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'pawn'


class Board
  POSITION = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

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

  def show
    @grid.map do |row|
      row.map do |piece|
        if piece
          piece.render
        else
          "__"
        end
      end.join(" ")
    end.join("\n")
  end

  def render
    puts show
  end

  def in_bound?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end

end

Board.new.render





