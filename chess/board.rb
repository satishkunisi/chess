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


  def in_check?(color)
    checking_king?(find_king_position(color), color)
  end

  def show

    counter = 8
    bg_color = :light_white
    puts "  " + ("a".."h").to_a.join(" ").colorize(:white)
    display_string = ""

     @grid.each do |row|
      bg_color =  bg_color == :light_blue ? :light_white : :light_blue

      display_string << "#{counter} ".colorize(:white)

      display_string << row.map do |piece, index|
        bg_color =  bg_color == :light_blue ? :light_white : :light_blue

        if piece
          "#{piece.render} ".colorize(:black).colorize(:background => bg_color)
        else
          "  ".colorize(:background => bg_color)
        end

      end.join('')
      display_string << "\n"

      counter -= 1
    end



    # display_string = @grid.map do |row|
    #   bg_color =  bg_color == :light_blue ? :light_white : :light_blue
    #   row.map do |piece, index|
    #     bg_color =  bg_color == :light_blue ? :light_white : :light_blue
    #     if piece
    #       "#{piece.render} ".colorize(:black).colorize(:background => bg_color)
    #     else
    #       "  ".colorize(:background => bg_color)
    #     end
    #     counter += 1
    #   end.join('')
    #
    # end
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

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  def in_bound?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  private
  def checking_king?(king_position, color)
    @grid.any? do |row|
      row.any? do |piece|
        piece && piece.moves.include?(king_position) && piece.color != color
      end
    end
  end

  def find_king_position(color)
    @grid.each do |row|
      row.each do |piece|
        return piece.pos if piece.class == King && piece.color == color
      end
    end

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
end









