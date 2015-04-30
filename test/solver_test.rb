require "minitest"
require "minitest/autorun"
require "/lib/solver"
require "/lib/sudoku"

class SolverTest < Minitest::Test

  def setup

    puzzle_text = File.read("/puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  end

  def test_it_solves
    assert false, "make it solve!"
  end

  def test_it_can_output_puzzle_text
    solver = Solver.new
  end


  # validation for solutions --- check row, column, and square
end
