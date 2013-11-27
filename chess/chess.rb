require_relative 'board'

class Chess
  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1
    @player2 = player2
    @player1.color = :white
    @player2.color = :black
    @current_player = @player1
  end

  def play
    until @board.over?
      @board.show
      take_turn
    end
    @board.show
    puts "#{@current_player.name} wins! Game over."
  end

  private
  def take_turn
    begin
      current_move = @current_player.get_move(@board)
      check_player_color(current_move)
      @board.move(current_move[0], current_move[1])
    rescue => error
      puts error.message
      retry
    end

    @current_player = (@current_player == @player1) ? @player2 : @player1
  end

  def check_player_color(current_move)
    unless @board[current_move[0]].color == @current_player.color
      raise "You are trying to move your opponent's piece."
    end
  end

end


class HumanPlayer
  attr_accessor :color
  attr_reader :name

  def initialize(name)
    @color = nil
    @name = name
  end

  def get_move(board)
    begin
      print "Enter your starting position (ex: a2): "

      start_pos = convert_input(gets.chomp)
      check_in_bound(board, start_pos)
    rescue => e
      puts e.message
      retry
    end

    begin
      print "Enter your end position (ex: a2): "

      end_pos = convert_input(gets.chomp)
      check_in_bound(board, end_pos)
    rescue => e
      puts e.message
      retry
    end

    [start_pos, end_pos]
  end

  private
  def check_in_bound(board, pos)
    raise "Postion entered is out of bounds" unless board.in_bound?(pos)
  end

  def convert_input(user_input)

    [ (user_input[1].to_i - 8).abs, ("a".."h").to_a.index(user_input[0]) ]
  end

end

game = Chess.new(HumanPlayer.new("Satish"), HumanPlayer.new("Fong"))
game.play