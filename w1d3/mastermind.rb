class Mastermind

  attr_reader :colors

  def initialize
    @colors = %w(R G B Y O P)
    @answer = @colors.shuffle[0..3].join
    @guess = ""
    @turns = 10
  end

  def run
    @turns.times do |turn|

      begin
        puts "Turn #{turn + 1}"
        puts "Enter your guess"
        @guess = gets.chomp.upcase
        validate_input(@guess)
      rescue => e
        puts e.message
        retry
      end

      if solved?
        puts "You won!"
        break
      else
        #logic
        puts "You guessed #{right} right, and #{close} close."
        puts "Guess again"
      end
    end
    puts "You are out of turns" unless solved?
  end

  def validate_input(user_input)
    if user_input.length == 4
      unless user_input.split('').all? { |char| @colors.include?(char) }
        raise "Please enter a valid color"
      end
    else
      raise "Your input must be four letters, no more, no less!!!!!"
    end
  end

  def close
    incorrects = (@guess.split('') - @answer.split('')).length
    @answer.length - incorrects - right
  end

  def right
    answer_arr = @answer.split('')
    corrects = 0

    @guess.split('').each_with_index do |letter, pos|
      if letter == answer_arr[pos]
        corrects += 1
      end
    end

    corrects
  end

  def solved?
    @answer == @guess
  end


end



game = Mastermind.new
game.run
