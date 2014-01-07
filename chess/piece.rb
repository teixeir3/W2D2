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

end


# Sliding Pieces: Biship / Rook / Queen

class SlidingPiece < Piece
  def moves(end_pos)
    path(end_pos).each do |path_pos|
      # check to see if there is another piece in the path
      unless @board[path_pos].nil?
        # If piece is your own color, your move is blocked
        raise InvalidMoveError if @board[path_pos].color == @color
        # if the piece is of the other color...
        if @board[path_pos].color != @color
          # you can take it if you are the end of your path
          if path_pos == end_pos
            @board[path_pos].remove
          else
            # otherwise you are blocked by that piece
            raise InvalidMoveError
          end
        end
      end
      @pos = end_pos
    end


    # it wouldn't be valid if there is a piece of the same color
    # if it's a piece of the opposing color, you can move to there but not past
    # the other piece needs to get removed from the board if so
  end

  def remove
    @pos = nil
    true
    # this gets called by a taking piece on the piece it takes
    # maybe this should be a board method?
  end
end

class Rook < SlidingPiece

  def path(end_pos)
    x_end,y_end = end_pos
    path = []

    if x_end != @pos[0]
      (@pos[0]+1..7).each do |x_pos|
        path << [x_pos,@pos[1]]
      end
    elsif y_end != @pos[0]
      (@pos[1]+1..y_end).each do |y_pos|
        path << [@pos[0], y_pos]
      end
    else
      raise InvalidMoveError
    end

    if path.last == end_pos
      return path
    else
      raise InvalidMoveError
    end
  end

end

# Stepping pieces: Knight (ref to knight's travails)/ King

# The pawn (last)


class InvalidMoveError < StandardError
end
