class FatalBoardError < StandardError
end

require_relative 'piece.rb'

class Board
  attr_reader :rows

  def default_board
    rows = Array.new(8) { Array.new(8) }
    rows = rows.each_with_index do |row, x|
      next if x.between?(2, 5)
      color = :white if x == 0 || x == 1
      color = :black if x == 6 || x == 7
      row.each_index do |y|
        if x == 1 || x == 6
          rows[x][y] = Pawn.new([x, y], self, color)
        else
          case y
          when 0, 7
            p color
            rows[x][y] = Rook.new([x, y], self, color)
          when 1, 6
            rows[x][y] = Knight.new([x, y], self, color)
          when 2, 5
            rows[x][y] = Bishop.new([x, y], self, color)
          when 3
            rows[x][y] = Queen.new([x, y], self, color)
          when 4
            rows[x][y] = King.new([x, y], self, color)
          end
        end
      end
    end
    rows
  end

  def initialize(rows = self.default_board)
    @rows = rows

  end

  def [](pos)
    # returns piece object at that pos
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, piece)
    # be careful using this method since it doesnt' update the piece's pos
    x, y = pos[0], pos[1]
    @rows[x][y] = piece
  end

  def move(start_pos, end_pos)
    begin
      start_piece = self[start_pos]
      start_piece.move(end_pos)
    rescue InvalidMoveError  # MOVE TO GAME CLASS AFTER TESTING
      puts "That piece can't move there, human. Try again."
    rescue NoMethodError
      puts "No piece at that location. Try again."
    end
  end

  def dup
    duped_rows = rows.map(&:dup)
    self.class.new(duped_rows)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def in_check?(color)
    # find king of color on the board return position,
    # see if any piece of opposing color can move to that position.
  end

  def find_king(color)
    @rows.each_index do | row_idx |
      king_idx = self.rows[row_idx].index { |cell| cell.class == King }
      if king_idx
        return [row_idx, king_idx] if self[[row_idx, king_idx]].color == color
      end
    end
    raise FatalBoardError
  end

  def render
    print "  "
    ("a".."h").each { |letter| print "#{letter} " }
    puts
    @rows.each_with_index do |row, i|
      print "#{i+1} "
      row.each do |cell|
        if cell.nil?
          print "_ "
        else
          print cell.render
        end
      end
      puts
    end
    nil
  end

end

 # def cols
#    cols = [[], [], []]
#    @rows.each do |row|
#      row.each_with_index do |mark, col_idx|
#        cols[col_idx] << mark
#      end
#    end
#
#    cols
#  end

 # def diagonals
#    down_diag = [[0, 0], [1, 1], [2, 2]]
#    up_diag = [[0, 2], [1, 1], [2, 0]]
#
#    [down_diag, up_diag].map do |diag|
#      # Note the `x, y` inside the block; this unpacks, or
#      # "destructures" the argument. Read more here:
#      # http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
#      diag.map { |x, y| @rows[x][y] }
#    end
#  end

  # def tied?
#     return false if won?
#
#     # no empty space?
#     @rows.all? { |row| row.none? { |el| el.nil? }}
#   end
#
#   def over?
#     # style guide says to use `or`, but I (and most others) prefer to
#     # use `||` all the time. We don't like two ways to do something
#     # this simple.
#     won? || tied?
#   end
#
#   def winner
#     (rows + cols + diagonals).each do |triple|
#       return :x if triple == [:x, :x, :x]
#       return :o if triple == [:o, :o, :o]
#     end
#
#     nil
#   end
#
#   def won?
#     !winner.nil?
#   end

