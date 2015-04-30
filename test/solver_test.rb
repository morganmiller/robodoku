require "minitest"
require "minitest/autorun"
require "./lib/solver"
# require "pride"
# require "./lib/sudoku"

class SolverTest < Minitest::Test

  def setup
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    @solver = Solver.new(puzzle_text)
  end

  def test_it_solves
    assert false, "make it solve!"
  end

  def test_it_can_output_puzzle_text
    skip
    assert_equal "", @solver.output_data
  end

  def test_it_can_split_data
    skip
    assert_equal "", @solver.split_data
  end

  def test_it_makes_a_board
    assert_equal "", @solver.make_board
    assert_equal "", @solver.build_square_map_array

  end


  # validation for solutions --- check row, column, and square
end
