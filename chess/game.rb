require_relative 'piece.rb'
require_relative 'board.rb'

class WrongPieceError < StandardError
end

class Game

  def initialize
    @board = Board.new
    @cur_player = :white
    @surrender = false
  end

  def play
    until lost?
      @board.render
      take_turn
      @cur_player = self.next_player
    end

    win_msg = "Checkmate, #{@cur_player} Player loses!"
    surrender_msg = "#{self.next_player} surrenders! PUNY HUMAN!"
    over_msg = ""

    @surrender ? over_msg = surrender_msg : over_msg = win_msg

    puts
    @board.render
    puts
    puts over_msg
    # SHOULD ALSO check if not in check and no valid moves => draw
  end

  def next_player
    @cur_player == :white ? next_player = :black : next_player = :white
    next_player
  end

  def take_turn
    begin
      puts
      puts "#{@cur_player} Player, enter your move (Ex: a7, a6) or q to quit"
      user_input = gets.chomp

      if user_input == "q"
        @surrender = true
      else
        usable_input = parse_input(user_input)
        @board.move(usable_input[0],usable_input[1])
      end

    rescue InvalidMoveError
      puts
      puts "That piece can't move there, human. Try again:"
      retry
    rescue NoMethodError
      puts
      puts "No piece at that location. Try again:"
      retry
    rescue WrongPieceError
      puts
      puts "Please pick a #{@cur_player} piece. Try again:"
      retry
    end

    nil
  end

  private

  def parse_input(user_input)
    #change board coords to array of startpos and endpos
    input_arr = user_input.split(",").map(&:strip)
    parsed_input = []
    input_arr.each do |coord|
      parsed_input << [(coord[1].to_i)-1, coord[0].ord - 97]
    end

    parsed_input
  end

  def lost?
    return true if @surrender
    return true if @board.checkmate?(@cur_player)
    return false
  end

end


if $PROGRAM_NAME == __FILE__
  Game.new.play
end