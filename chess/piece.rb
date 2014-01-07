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
    end
    self.pos = end_pos
  end

end

class Rook < SlidingPiece

  def path(end_pos)
    x_end,y_end = end_pos
    path = []

    if x_end > @pos[0]
      (@pos[0]+1..x_end).each do |x_pos|
        path << [x_pos,@pos[1]]
      end
    elsif x_end < @pos[0]
      (pos[0]-1).downto(x_end) do |x_pos|
        path << [x_pos,@pos[1]]
      end
    elsif y_end > @pos[1]
      (@pos[1]+1..y_end).each do |y_pos|
        path << [@pos[0], y_pos]
      end
    elsif y_end < @pos[1]
      (pos[1]-1).downto(y_end) do |y_pos|
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

class Bishop < SlidingPiece

  def path(end_pos)
    x_end,y_end = end_pos
    path = []
    y_pos = @pos[1]

    if x_end > @pos[0]
      (@pos[0]+1..x_end).each do |x_pos|
        if y_end > @pos[1]
          y_pos += 1
        else
          y_pos -= 1
        end
        path << [x_pos, y_pos]
      end

    elsif x_end < @pos[0]
      (pos[0]-1).downto(x_end) do |x_pos|
        if y_end > @pos[1]
          y_pos += 1
        else
          y_pos -= 1
        end
        path << [x_pos, y_pos]
      end
    else
      raise InvalidMoveError
    end
    path

  end

end

# Stepping pieces: Knight (ref to knight's travails)/ King

# The pawn (last)


class InvalidMoveError < StandardError
end
