class Cell
  
  attr_reader :solution, :row, :column, :square
  
  def initialize(solution, designator)
    @solution = solution
    @row = designator[1]
    @column = designator[0]
    @square = designator[2]
  end
  
  def solved?
    @solution != 0
  end
  
end
