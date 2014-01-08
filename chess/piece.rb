# Piece parent class
class Piece
  attr_reader :pos, :board, :color

  UNICODES = {
    :w_king => "\u2654",
    :w_queen => "\u2655",
    :w_rook => "\u2656",
    :w_bishop => "\u2657",
    :w_knight => "\u2658",
    :w_pawn => "\u2659",
    :b_king => "\u265A",
    :b_queen => "\u265B",
    :b_rook => "\u265C",
    :b_bishop => "\u265D",
    :b_knight => "\u265E",
    :b_pawn => "\u265F"
  }

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def to_sym
    "#{@color[0]}_#{self.class}".downcase.to_sym
  end

  def move(end_pos)
    if self.moves.include?(end_pos)
      self.pos = end_pos
    else
      raise InvalidMoveError
    end
  end

  def render
    "#{UNICODES[self.to_sym]} "
  end

  protected

  def remove
    self.board[@pos]= nil
    true
    # note that this updates the board, but the removed piece still thinks it has a pos
  end

  private

  def pos=(new_pos)
    self.board[@pos]= nil
    @pos = new_pos
    self.board[@pos] = self
  end

  def off_board?(pos)
    !(pos[0].between?(0,7) && pos[1].between?(0,7))
  end

end


class SteppingPiece < Piece

  def moves
    possible_moves = []

    move_dirs.each do |move_dir|
      current_pos = [@pos[0] + move_dir[0],
        @pos[1] + move_dir[1]]
      next if off_board?(current_pos)
      possible_moves << current_pos if board[current_pos].nil? ||
        board[current_pos].color != self.color
    end

    possible_moves
  end

end

class King < SteppingPiece
  DELTAS = [
    [1,0],
    [-1,0],
    [0,1],
    [0,-1],
    [1,1],
    [-1,-1],
    [1,-1],
    [-1,1]
  ]

  def move_dirs
    DELTAS
  end

end

class Knight < SteppingPiece
  DELTAS = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def move_dirs
    DELTAS
  end

end


class Pawn < Piece

  def moves # DOES NOT WORK CORRECTLY -- moves horizontally
    x_pos, y_pos = @pos
    moves = []

    if color == :white
      moves << [x_pos, y_pos + 1]
      moves << [x_pos, y_pos + 2] if y_pos == 1 && @board[[x_pos,y_pos+1]].nil?
    elsif color == :black
      moves << [x_pos, y_pos - 1]
      moves << [x_pos, y_pos - 2] if y_pos == 6 && @board[[x_pos,y_pos-1]].nil?
    end
    moves = moves.select { |move|  @board[move].nil? }

    take_moves = []
    if color == :white
      take_moves << [x_pos + 1, y_pos + 1] unless @board[[x_pos + 1, y_pos + 1]].nil?
      take_moves << [x_pos-1, y_pos + 1] unless @board[[x_pos-1, y_pos + 1]].nil?
    else
      take_moves << [x_pos + 1, y_pos - 1] unless @board[[x_pos + 1, y_pos - 1]].nil?
      take_moves << [x_pos-1, y_pos - 1] unless @board[[x_pos-1, y_pos - 1]].nil?
    end
    moves += take_moves.select { |move| @board[move].color != self.color }
  end

end


# Sliding Pieces: Biship / Rook / Queen

class SlidingPiece < Piece

  def moves
    possible_moves = []

    move_dirs.each do |move_dir|
      current_pos = @pos
      # until we hit a problem, continue mapping the current position
      begin
        current_pos = [current_pos[0] + move_dir[0],
        current_pos[1] + move_dir[1]]
        break if off_board?(current_pos)
        possible_moves << current_pos if board[current_pos].nil?
      end while board[current_pos].nil?

      next if off_board?(current_pos)
      possible_moves << current_pos if board[current_pos].color != self.color
    end

    possible_moves
  end

end

class Rook < SlidingPiece

  DELTAS = [
    [1,0],
    [-1,0],
    [0,1],
    [0,-1]
  ]

  def move_dirs
    DELTAS
  end

end

class Bishop < SlidingPiece

  DELTAS = [
    [1,1],
    [-1,-1],
    [1,-1],
    [-1,1]
  ]

  def move_dirs
    DELTAS
  end
end

class Queen < SlidingPiece
  DELTAS = [
    [1,0],
    [-1,0],
    [0,1],
    [0,-1],
    [1,1],
    [-1,-1],
    [1,-1],
    [-1,1]
  ]

  def move_dirs
    DELTAS
  end
end

# Stepping pieces: Knight (ref to knight's travails)/ King

# The pawn (last)


class InvalidMoveError < StandardError
end
