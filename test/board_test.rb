require "minitest"
require "minitest/autorun"
require 'minitest/pride'
require "./lib/solver"

class BoardTest < Minitest::Test

  def test_it_can_parse_the_puzzle_text
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    board = Board.new(puzzle_text)

    assert_equal [0, 2, 6, 5, 9, 4, 3, 1, 7, 7, 1, 5, 6,
        3, 8, 9, 4, 2, 3, 9, 4, 7, 2, 1, 8, 6, 5, 1, 6, 3,
        4, 5, 9, 2, 7, 8, 9, 4, 8, 2, 6, 7, 1, 5, 3, 2, 5,
        7, 8, 1, 3, 6, 9, 4, 5, 3, 1, 9, 4, 2, 7, 8, 6, 4,
        8, 2, 1, 7, 6, 5, 3, 9, 6, 7, 9, 3, 8, 5, 4, 2, 1],
      board.split_data
  end

  def test_it_knows_correct_final_designators
    puzzle_text = File.read("./puzzles/easy_sample.txt")
    board = Board.new(puzzle_text)

    assert_equal ["a1z", "b1z", "c1z", "d1y", "e1y", "f1y", "g1x",
        "h1x", "i1x","a2z", "b2z", "c2z", "d2y", "e2y", "f2y", "g2x",
        "h2x", "i2x", "a3z", "b3z", "c3z", "d3y", "e3y", "f3y", "g3x",
        "h3x", "i3x", "a4w", "b4w", "c4w", "d4v", "e4v", "f4v", "g4u",
        "h4u", "i4u", "a5w", "b5w", "c5w", "d5v", "e5v", "f5v", "g5u",
        "h5u", "i5u", "a6w", "b6w", "c6w", "d6v", "e6v", "f6v", "g6u",
        "h6u", "i6u", "a7t", "b7t", "c7t", "d7s", "e7s", "f7s", "g7r",
        "h7r", "i7r", "a8t", "b8t", "c8t", "d8s", "e8s", "f8s", "g8r",
        "h8r", "i8r", "a9t", "b9t", "c9t", "d9s", "e9s", "f9s", "g9r",
        "h9r", "i9r"], board.final_designators
  end
end

