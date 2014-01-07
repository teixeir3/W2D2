class Board
  attr_reader :rows

  def self.blank_grid
    Array.new(8) { Array.new(8) }
  end

  def initialize(rows = self.class.blank_grid)
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
    # calls move on piece at the start_pos and passes end_pos
    # handles exceptions / errors
    # updates the board with piece in new positon
  end

  def dup
    duped_rows = rows.map(&:dup)
    self.class.new(duped_rows)
  end

  def empty?(pos)
    self[pos].nil?
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

