require_relative 'piece.rb'
require_relative 'board.rb'

class Game

  def initialize
    @board = Board.new
    @current_player = :white
  end

  def play
    until lost?
      take_turn
    end

    # SHOULD ALSO check if not in check and no valid moves => draw
    # in loop prompt user for input
    # parse input to board-usable positions
    # switch turns
    end
  end

  def take_turn
    begin
      user_input = gets.chomp
      usable_input = parse_input(user_input)
      @board.move(usable_input[0],usable_input[1])
    rescue InvalidMoveError
      puts "That piece can't move there, human. Try again."
    rescue NoMethodError
      puts "No piece at that location. Try again."
    end
  end

  def parse_input(user_input)
    #change to array of startpos and endpos
  end

  def lost?
    @board.checkmate?(@current_player)
  end



end