class Hangman

  def initialize(guesser, speaker)
    @guesser = guesser
    @speaker = speaker
    @secret_word = Array.new(@speaker.secret_word_length) { "_" }
    @turns = 20
    @letters_guessed = []
  end

  def run
    @turns.times do |turn|
      show(turn)
      guess
      break if game_over?
    end

    if game_over?
      puts "#{@guesser.name} wins! The word was '#{@secret_word.join}'."
    else
      puts "#{@guesser.name} is out of turns! Game over!"
    end

  end

  def game_over?
    # !@secret_word.include?('_')
    @secret_word.none?{|char|char == '_'}
  end

  def guess
    #word_length = @speaker.secret_word_length
    letter = @guesser.pick_letter(@secret_word)
    positions = @speaker.check_in_word(letter)
    positions.each do |pos|
      @secret_word[pos] = letter
    end
    @letters_guessed << letter
  end

  def show(turn)
    puts "Turn #{turn+1} / #{@turns}"
    puts "Secret word: #{@secret_word.join}"
    puts "Letters guessed: #{@letters_guessed.join(',')}"
  end

end

class HumanPlayer

  attr_reader :name

  def initialize(name)
    @secret_word_length = 0
    @name = name
  end

  #when guesser
  def pick_letter(secret_word)
    begin
      print "Pick a letter: "
      user_input = gets.chomp
      one_letter?(user_input)
      is_letter?(user_input)
    rescue => e
      puts e.message
      retry
    end
  end

  def one_letter?(user_input)
    raise "That's more than one letter." if user_input.length != 1
    user_input
  end

  def is_letter?(user_input)
    raise "not a letter" unless ('a'..'z').include?(user_input.downcase)
    user_input
  end

  # When speaker
  def secret_word_length
    print "What is the length of your word? "
    gets.chomp.to_i
  end

  def check_in_word(letter)
    print "What are the positions of '#{letter}' in your word? ex: 1,2 "
    puts "Hit enter if letter not in word"
    gets.chomp.split(',').map { |i| i.to_i - 1 }
  end

end

class ComputerPlayer

  attr_reader :name

  def initialize(name)
    @dictionary =  File.readlines("dictionary.txt")
    @letters_guessed = []
    @secret_word = @dictionary.sample.chomp
    @secret_word_length = 0
    @sub_dictionary = @dictionary
    @name = name
  end

  # When guesser
  def pick_letter(secret_word)
    #("a".."z").to_a.sample
    set_dictionary(secret_word)
    letter = most_common_letter
    @letters_guessed << letter unless @letters_guessed.include?(letter)
    letter
  end

  def most_common_letter
    max_value = 0
    letter = ""
    letter_frequency.each do |key, value|
      if value > max_value
        letter = key
        max_value = value
      end
    end
    letter
  end

  def letter_frequency
    frequency = Hash.new(0)
    @sub_dictionary.each do |word|
      word.split('').each do |letter|
        unless @letters_guessed.include?(letter)
          frequency[letter] += 1
        end
      end
    end

    frequency
  end

  def set_dictionary(secret_word)
    smaller_dictionary = []

    @sub_dictionary.each do |word|
      word = word.chomp
      if (word.length == secret_word.length)
        word_possible= true

        word.split('').each_with_index do |letter, index|
          unless secret_word[index] == '_' || letter == secret_word[index]
            word_possible = false
          end
        end

        smaller_dictionary << word if word_possible
      end
    end
    @sub_dictionary = smaller_dictionary
  end

  # When speaker
  def secret_word_length
    @secret_word.length
  end

  def check_in_word(letter)
    letter = letter.downcase

    indicies = []
    @secret_word.split('').each_with_index do |secret_letter, index|
      if (secret_letter == letter)
        indicies << index
      end
    end

    indicies
  end
end

me = HumanPlayer.new("Me")
you = HumanPlayer.new("You")
c1 = ComputerPlayer.new("C1")
c2 = ComputerPlayer.new("C2")

game = Hangman.new(me, c2)
#game = Hangman.new(c1,me)
game.run