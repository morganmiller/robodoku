require "minitest"
require "minitest/autorun"
require 'minitest/pride'
require "./lib/solver"

class SolverTest < Minitest::Test

  def test_it_makes_a_board
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)

    assert solver.board.is_a?(Array)
    assert solver.board[1].is_a?(Cell)
    assert_equal 81, solver.board.uniq.length
  end

  def test_it_can_find_row_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)

    assert solver.row_peers.is_a?(Hash)
    assert_equal 9, solver.row_peers["1"].length
    assert_equal "4", solver.row_peers["4"].last.row
  end

  def test_it_can_find_square_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)

    assert solver.square_peers.is_a?(Hash)
    assert_equal 9, solver.square_peers["r"].length
    assert_equal "z", solver.square_peers["z"].last.square
  end

  def test_it_can_find_column_peers
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)

    assert solver.column_peers.is_a?(Hash)
    assert_equal 9, solver.column_peers["h"].length
    assert_equal "i", solver.column_peers["i"].last.column
  end

  def test_it_solves_puzzle_with_one_empty
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    solver = Solver.new(puzzle_text)

    refute solver.puzzle_solved?
    solver.solve
    assert solver.puzzle_solved?
  end

  def test_it_solves_super_easy_puzzle
    puzzle_text = File.read("./puzzles/solve_new.txt")
    solver = Solver.new(puzzle_text)

    refute solver.puzzle_solved?
    solver.solve
    assert solver.puzzle_solved?
  end

  def test_it_solves_less_easy_puzzle
    puzzle_text = File.read("./puzzles/easy_1.txt")
    solver = Solver.new(puzzle_text)

    refute solver.puzzle_solved?
    solver.solve
    assert solver.puzzle_solved?
  end

  def test_it_solves_medium_puzzle
    skip
    puzzle_text = File.read("./puzzles/medium.txt")
    solver = Solver.new(puzzle_text)

    refute solver.puzzle_solved?
    solver.solve
    assert solver.puzzle_solved?
  end
end
