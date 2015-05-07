require_relative 'board'
require 'pry'

class Solver

  attr_reader :board

  def initialize(puzzle_text)
    @board = Board.new(puzzle_text).make_board
  end

  def rows
    ("1".."9").to_a
  end

  def columns
    ("a".."i").to_a
  end

  def squares
    ("r".."z").to_a
  end

  def row_peers
    @board.group_by do |cell|
      cell.row
    end
  end

  def column_peers
    @board.group_by do |cell|
      cell.column
    end
  end

  def square_peers
    @board.group_by do |cell|
      cell.square
    end
  end

  def all_possibilities
    (1..9).to_a
  end

  def all_peers(cell)
    peers = square_peers[cell.square] + column_peers[cell.column] + row_peers[cell.row]
    peers.uniq.delete_if {|peer| peer == cell}
  end

  def unique_peer_values(cell)
    all_peers(cell).map do |peer|
      peer.solution unless peer.solution == 0
    end.uniq
  end

  def possible_solutions(cell)
    all_possibilities.delete_if{ |num| unique_peer_values(cell).include?(num) }
  end

  def cells_to_solve
    @board.select {|cell| !cell.solved? }
  end

  def cells_with_one_solution
    cells_to_solve.select do |cell|
      possible_solutions(cell).length == 1
    end
  end

  def empty_cells_for_peer_group(peer_group, designator)
    peer_group[designator].select do |cell|
      cells_to_solve.include?(cell)
    end
  end
  
  def needed_numbers_for_peer_group(peer_group, designator)
    empty_cells_for_peer_group(peer_group, designator).flat_map do |cell|
      possible_solutions(cell)
    end.uniq
  end

  def find_singular_possibilities(peer_group, designator)
    needed = needed_numbers_for_peer_group(peer_group, designator)
    empty = empty_cells_for_peer_group(peer_group, designator)
    needed.each do |num|
      solutions = []
      empty.each do |cell|
        solutions << cell if possible_solutions(cell).include?(num)
      end
      if solutions.length == 1
        solutions[0].solution = num
      end
    end
  end
  
  def find_singular_possibilities_for_group(group, group_peers)
    group.each do |designator|
      find_singular_possibilities(group_peers, designator)
    end
  end
  
  def find_singular_possibilities_for_all
    find_singular_possibilities_for_group(rows, row_peers)
    find_singular_possibilities_for_group(columns, column_peers)
    find_singular_possibilities_for_group(squares, square_peers)
  end

  def puzzle_solved?
    cells_to_solve.length == 0
  end

  def solve
    until puzzle_solved?
      cells_with_one_solution.each do |cell|
        cell.solution = possible_solutions(cell).first
      end
      find_singular_possibilities_for_all
    end
    print_board
  end

  def print_board
    @board.map do |cell|
      cell.solution
    end.each_slice(9) do |slice|
      puts slice.join
    end
  end
end

