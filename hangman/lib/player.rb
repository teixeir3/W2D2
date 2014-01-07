class InvalidGuessError < StandardError
end

class DuplicateGuessError < StandardError
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def receive_secret_length(secret_length)
    secret_length
  end

end

class HumanPlayer < Player

  def guess(board, incorrect_letters)
    puts "Guess a letter:"
    begin
      guess = gets.chomp.downcase
      if board.include?(guess) || incorrect_letters.include?(guess)
        raise DuplicateGuessError.new
      elsif !guess.match(/^[a-z]$/)
        raise InvalidGuessError.new
      end
    rescue DuplicateGuessError
      puts "You've already guessed that. Please guess again:"
    rescue InvalidGuessError
      puts "Please enter a single letter:"
    end
    guess
  end

  def pick_secret_word
    puts "Please think of a secret word"
    puts "How many letters does your word have?"
    begin
      secret_length = Integer(gets.chomp)
    rescue ArgumentError
      puts "Please enter a valid length"
      retry
    end
  end

  def check_guess_response(guess)
    puts "Does your word contain the letter \'#{guess}\' (y/n)?"
    response = gets.chomp.downcase
    loop do
      break if response == "y" || response == "n"
      puts "Please respond \'y\' or \'n\'"
      response = gets.chomp.downcase
    end
    return [] if response == 'n'
    get_positions
  end

  def require_secret
    puts "What word were you thinking of?"
    secret = gets.chomp.downcase
  end

  private

  def get_positions
    puts "Where does your letter occur in the word?"
    puts "Please enter all the position numbers separated by spaces:"
    begin
      response_indices = gets.chomp.split(" ").map { |char| Integer(char) }
    rescue
      puts "Please enter valid positions"
      retry
    end
    response_indices.map { |index| index-1 }
  end

end

class ComputerPlayer < Player
  DICTIONARY = File.readlines("./dictionary.txt").map(&:chomp)

  def pick_secret_word
    loop do
      @secret_letters = DICTIONARY.sample.split("")
      return @secret_letters.length if @secret_letters.length > 1
    end
  end

  def check_guess_response(guess)
    response_indices = []
    @secret_letters.each_with_index do |letter, i|
      response_indices << i if guess == letter
    end
    response_indices
  end

  def require_secret
    @secret_letters.join("")
  end

  def receive_secret_length(secret_length)
    super
    @potential_words = DICTIONARY.select{ |word| word.length == secret_length }
  end

  def guess(board, incorrect_letters)
    @potential_words = filter_potential_words(board, incorrect_letters)
    letter_freqs = calc_letter_freqs
    guess = letter_freqs.pop[0]
    while board.include?(guess)
      guess = letter_freqs.pop[0]
    end
    guess
  end

  private

  def filter_potential_words(board, incorrect_letters)
    @potential_words.reject do |word|
      (incorrect_letters.any? { |letter| word.include?(letter) }) ||
      (!match_board?(board, word))
    end
  end

  def match_board?(board, word)
    letters = word.split("")
    letters.each_index do |i|
      next if board[i].nil?
      return false if board[i] != letters[i]
    end
    true
  end

  def calc_letter_freqs
    letter_freqs = Hash.new(0)
    @potential_words.each do |word|
      word.each_char do |char|
        letter_freqs[char] += 1
      end
    end
    letter_freqs.sort_by { |key, val| val }
  end

end