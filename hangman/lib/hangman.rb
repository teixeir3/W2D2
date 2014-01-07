#!/usr/bin/env ruby

require './lib/player.rb'

class Hangman
  MAX_WRONG = 5

  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player
    @checking_player = checking_player
    @incorrect_letters = []
  end

  def run
    secret_length = @checking_player.pick_secret_word
    @guessing_player.receive_secret_length(secret_length)
    @board = Array.new(secret_length, nil)
    until won? || lost?
      take_turn
    end
    if lost?
      puts
      puts "#{@checking_player.name} wins!"
      puts "The secret word was #{@checking_player.require_secret}"
    else
      puts
      puts "#{@guessing_player.name} wins!"
    end
  end

  def won?
    @board.none?{ |el| el.nil? }
  end

  def lost?
    @incorrect_letters.length == MAX_WRONG
  end

  private

  def take_turn
    guess = @guessing_player.guess(@board, @incorrect_letters)
    response_indices = @checking_player.check_guess_response(guess)
    if response_indices.empty?
      @incorrect_letters << guess
    else
      response_indices.each do |index|
        @board[index] = guess
      end
    end
    render_board
    nil
  end

  def render_board
    print "Secret word: "
    @board.each do |space|
      if space.nil?
       print "_"
      else
        print space
      end
    end
    puts
  end

end

if __FILE__ == $PROGRAM_NAME
  player1 = HumanPlayer.new("Katie")
  player2 = ComputerPlayer.new("Robot")
  game = Hangman.new(player2, player1)
  game.run
end


