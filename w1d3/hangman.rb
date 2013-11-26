class Hangman

  def initialize(guesser, speaker)
    @guesser = guesser
    @speaker = speaker
    @correct_letters_guessed = []
    @incorrect_letters_guessed = []
    @secret_word = speaker.secret_word.downcase
    @turns = 20
    @letters_guessed = []
  end

  def run
    @turns.times do
      show
      guess
      break if game_over?
    end

    if game_over?
      puts "You win!"
    else
      puts "You're out of turns! Game over!"
    end

  end

  def game_over?
    (@secret_word.split('') - @correct_letters_guessed).empty?
    #speaker.secret_word?
  end

  def guess
    letter = @guesser.pick_letter(@secret_word.length,
                                  @corect_letters_guessed).downcase

    letters_guessed = @correct_letters_guessed + @incorrect_letters_guessed
    if letters_guessed.include?(letter)
      puts "Already guessed that letter"
      guess
    elsif @secret_word.split('').include?(letter)
      @correct_letters_guessed << letter
      true
    else
      @incorrect_letters_guessed << letter
      false
    end
  end

  def show
    censored_arr = @secret_word.split('').map do |letter|
      if @correct_letters_guessed.include?(letter)
        letter
      else
        "_"
      end
    end

    puts "Secret Word: #{censored_arr.join}"
  end

end

class HumanPlayer

  def secret_word
    print "What is your word? "
    gets.chomp
  end

  def pick_letter(word_length, corect_letters_guessed)
    print "Pick a letter: "
    gets.chomp
  end


end

class ComputerPlayer

  def initialize
    @dictionary =  File.readlines("dictionary.txt")
    @letters_guessed = []
  end

  def secret_word
    @dictionary.sample.chomp
  end

  def pick_letter(word_length, corect_letters_guessed)
    ("a".."z").to_a.sample
  end

end

me = HumanPlayer.new
them = ComputerPlayer.new
game = Hangman.new(them, me)
game.run