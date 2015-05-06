require "minitest"
require "minitest/autorun"
require 'minitest/pride'
require "./lib/solver"
# require "pride"
# require "./lib/sudoku"

class SolverTest < Minitest::Test

  def test_it_can_parse_the_puzzle_text
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal [0, 2, 6, 5, 9, 4, 3, 1, 7, 7, 1, 5, 6,
        3, 8, 9, 4, 2, 3, 9, 4, 7, 2, 1, 8, 6, 5, 1, 6, 3,
        4, 5, 9, 2, 7, 8, 9, 4, 8, 2, 6, 7, 1, 5, 3, 2, 5,
        7, 8, 1, 3, 6, 9, 4, 5, 3, 1, 9, 4, 2, 7, 8, 6, 4,
        8, 2, 1, 7, 6, 5, 3, 9, 6, 7, 9, 3, 8, 5, 4, 2, 1],
    solver.split_data
  end
  
  def test_it_makes_a_board
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal 0, solver.board["a1z"]
    assert_equal 6, solver.board["c1z"]
    assert_equal 1, solver.board["i9r"]
  end
  
  def test_it_can_solve_easy_puzzle
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    solver.solve
    assert_equal 8, solver.board["a1z"]
  end
  
  def test_it_can_find_row_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal [6, 5, 9, 4, 3, 1, 7], solver.row_peers("b1z")
  end
  
  def test_it_can_find_square_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal [6, 7, 1, 5, 3, 9, 4], solver.square_peers("b1z")
  end
  
  def test_it_can_find_column_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal [1, 9, 6, 4, 5, 3, 8, 7], solver.column_peers("b1z")
  end
  
  def test_it_finds_needed_numbers_for_row
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)
  
    assert_equal [8], solver.needed_numbers_for_group("a")
  end

  def test_it_solves_easy_1
    puzzle_text = File.read("./puzzles/solve_new.txt")
    solver = Solver.new(puzzle_text)
    
    refute solver.solved?
    solver.solve
    assert solver.solved?
  end

  


  # validation for solutions --- check row, column, and square
end
