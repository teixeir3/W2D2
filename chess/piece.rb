# Piece parent class
class Piece
  attr_reader :pos, :board, :color

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

end


# Sliding Pieces: Biship / Rook / Queen

class SlidingPiece < Piece
  def moves(end_pos)
    move_dirs(end_pos)

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

  def move_dirs(end_pos)
    x_end,y_end = end_pos
    path = []

    if x_end != @pos[0]
      (@pos[0]..7).each do |x_pos|
        path << [x_pos,@pos[1]]
        return path if path.last == end_pos
      end
      raise InvalidMoveError
    elsif y_end != @pos[0]
      (@pos[1]..7).each do |y_pos|
        path << [@pos[0], y_pos]
        return path if path.last == end_pos
      end
      raise InvalidMoveError
    else
      raise InvalidMoveError
    end

  end

end

# Stepping pieces: Knight (ref to knight's travails)/ King

# The pawn (last)


class InvalidMoveError < StandardError
end
