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

    puts "#{@current_player.name} wins! Game over."
  end


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
      print "Enter your starting position (ex: 1,0): "
      start_pos = gets.chomp.split(',').map(&:to_i)
      check_in_bound(board, start_pos)
    rescue => e
      puts e.message
      retry
    end

    begin
      print "Enter your end position (ex: 1,0): "
      end_pos = gets.chomp.split(',').map(&:to_i)
      check_in_bound(board, end_pos)
    rescue => e
      puts e.message
      retry
    end

    [start_pos, end_pos]
  end

  def check_in_bound(board, pos)
    raise "Postion entered is out of bounds" unless board.in_bound?(pos)
  end

end

game = Chess.new(HumanPlayer.new("Satish"), HumanPlayer.new("Fong"))
game.play