# Piece parent class
class Piece
  attr_reader :pos, :board

  def initialize(pos, board)
    @pos = pos
    @board = board
  end

end


# Sliding Pieces: Biship / Rook / Queen

class SlidingPiece < Piece
  def moves(end_pos)
    move_dirs
    # move needs to check which directions it can move in
    # check each position in that direction to see if it's a valid move
    # it wouldn't be valid if there is a piece of the same color
    # if it's a piece of the opposing color, you can move to there but not past
    # the other piece needs to get removed from the board if so
  end

  def remove
    # this gets called by a taking piece on the piece it takes
    # maybe this should be a board method?
  end
end

class Rook < SlidingPiece

  def move_dirs
    # returns list of reachable squares regardless of other pieces' positions
    reachable_pos_arr = []
    (0..7).each do |num|
      reachable_pos_arr << [pos[0], num]
      reachable_pos_arr << [num, pos[1]]
    end
    reachable_pos_arr
  end

end

# Stepping pieces: Knight (ref to knight's travails)/ King

# The pawn (last)
