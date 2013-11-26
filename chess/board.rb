class Board
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  def in_bound?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end
end
