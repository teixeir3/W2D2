class FatalBoardError < StandardError
end

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
    start_piece = self[start_pos]
    if start_piece.valid_moves.include?(end_pos)
      start_piece.pos = end_pos
      self[start_pos] = nil
      self[end_pos] = start_piece
    else
      raise InvalidMoveError
    end
    self
  end

  def move!(start_pos, end_pos)
    start_piece = self[start_pos]
    if start_piece.moves.include?(end_pos)
      start_piece.pos = end_pos
      self[start_pos] = nil
      self[end_pos] = start_piece
    else
      raise InvalidMoveError
    end
    self
  end

  def dup
    # new board object
    # go through original board's array of arrays and dup every object
    duped_rows = rows.map(&:dup)
    pieces = duped_rows.flatten.reject { |cell| cell.nil? }


    duped_rows.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_cell = duped_rows[row_idx][col_idx]
        next if current_cell.nil?
        duped_rows[row_idx][col_idx] = current_cell.dup
      end
    end
    duped_board = self.class.new(duped_rows)
    # THIS COMMENTED OUT VERSION BREAKS MOVE INTO CHECK
    # pieces.each do |piece|
    #   piece.board = duped_board
    # end
    duped_board.rows.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_cell = duped_board[[row_idx, col_idx]]
        next if current_cell.nil?
        current_cell.board = duped_board
      end
    end
    duped_board
  end

  def pieces
    # returns arr of pieces
    self.rows.flatten.reject { |cell| cell.nil? }
  end

  def empty?(pos)
    self[pos].nil?
  end

  def in_check?(color)
    king_pos = find_king(color)
    @rows.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_cell = @rows[row_idx][col_idx]
        if current_cell.nil? || current_cell.color == color
          next
        else
          return true if current_cell.moves.include?(king_pos)
        end
      end
    end
    false
   end

   def checkmate?(color)
     players_pieces = pieces.select { |piece| piece.color == color }

     in_check?(color) && players_pieces.none? {|piece| piece.valid_moves.length > 0 }
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

