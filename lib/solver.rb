require 'pry'

class Solver

  attr_reader :board

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
    @board = make_board
  end

  ###Parser is chopping off spaces if they are at the end of the line
  def split_data
    @puzzle_text.split("\n").map(&:chars).flatten.map(&:to_i)
  end

  def columns
    ("a".."i").to_a
  end

  def rows
    ("1".."9").to_a
  end

  def squares
    ("r".."z").to_a
  end

  def to_be_replaced_by_rows
    ["x"] * 9
  end

  def to_sub_with_numbers
    columns.zip(to_be_replaced_by_rows).map(&:join)
  end

  def columns_and_rows
    positions = []
    9.times do |time|
      positions << to_sub_with_numbers.map do |pair|
        pair.gsub('x', (time+1).to_s)
      end
    end
    positions
  end

  def shovel_squares(squares, first, second, third)
    3.times do
      squares << [first[0], first[0], first[0]]
      squares << [second[0], second[0], second[0]]
      squares << [third[0], third[0], third[0]]
    end
  end

  def square_assignments
    first = ["z","w","t"]
    second = ["y","v","s"]
    third = ["x","u","r"]
    squares = []
    3.times do
      shovel_squares(squares, first, second, third)
      first.rotate!; second.rotate!; third.rotate!
    end
    squares.flatten
  end

  def final_designators
    columns_and_rows.flatten.zip(square_assignments).map(&:join)
  end

  def make_board
    final_designators.flatten.zip(split_data).to_h
  end

  def unique_peers(peers)
    peers.delete_if {|num| num == 0}.uniq
  end

  def find_peer_cells(cell, num)
    @board.keys.select { |other| cell[num] == other[num] unless other == cell }
  end

  def row_peers(cell)
    find_peer_cells(cell, 1).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def column_peers(cell)
    find_peer_cells(cell, 0).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def square_peers(cell)
    find_peer_cells(cell, 2).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def all_peers(cell)
    unique_peers(column_peers(cell) + square_peers(cell) + row_peers(cell))
  end

  def empty_cells
    @board.keys.inject([]) do |empty_cells, cell|
      empty_cells << cell if @board[cell] == 0 || @board[cell].nil?; empty_cells
    end
  end

  def cell_to_solve
    empty_cells.sort_by { |cell| all_peers(cell).length }.last
  end

  def all_possible_numbers
    (1..9).to_a
  end

  def compare_numbers(cell)
    all_possible_numbers.delete_if{ |num| all_peers(cell).include?(num) }
  end

  def needed_numbers_for_group(designator)
    all_values = []
    @board.each do |cell, value|
      if cell.include?(designator)
        all_values << value
      end
    end
    all_possible_numbers.delete_if {|num| all_values.include?(num)}
  end

  def all_empty_cells_for_group(designator)
    all_cells = []
    @board.each do |cell, _value|
      if cell.include?(designator)
        all_cells << cell
      end
    end
    all_cells.select { |cell| empty_cells.include?(cell) }
  end

  def check_peers(designator)
    needed = needed_numbers_for_group(designator)
    needed.length.times do
      count = 0
      all_empty_cells_for_group(designator).each do |cell|
        if all_peers(cell).include?(needed.last)
          count +=1
        end
      end
      # puts "count: #{count} \n comparator: #{all_empty_cells_for_group(designator).length-1}"
      if count == (all_empty_cells_for_group(designator).length - 1)
        solved_cell = all_empty_cells_for_group(designator).detect do |cell|
          !all_peers(cell).include?(needed.last)
        end
        puts solved_cell
        @board[solved_cell] = needed.last
      end
      needed.pop
    end
  end

  def check_them_all
    rows.each {|row| check_peers(row)}
    columns.each {|col| check_peers(col)}
    squares.each {|sq| check_peers(sq)}

  end

  def solved?
    !@board.values.include?(0)
  end

  def solve
    puts @board.values.select {|v| v==0}.length
    puts @board
    until solved?
      if all_peers(cell_to_solve).length == 8
        @board[cell_to_solve] = compare_numbers(cell_to_solve)[0]
      end
      check_them_all
      puts @board.values.select {|v| v==0}.length
      # puts @board
    end
  end
end
