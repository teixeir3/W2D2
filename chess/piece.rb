# Piece parent class
class Piece
  attr_reader :pos, :board, :color

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def to_s
    "#{@color} #{self.class}"
  end

  def move(end_pos)
    if self.moves.include?(end_pos)
      self.pos = end_pos
    else
      raise InvalidMoveError
    end
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
