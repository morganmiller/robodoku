require 'pry'


class Solver

  attr_reader :board

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
    @board = make_board
  end
  
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

  def order_squares(squares, first, second, third)
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
      order_squares(squares, first, second, third)
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

  def find_peer_cells(cell, index)
    @board.keys.select { |other| cell[index] == other[index] unless other == cell }
  end

  def row_peers(cell)
    find_peer_cells(cell, 1).map do |peer|
      peer
    end
  end

  def column_peers(cell)
    find_peer_cells(cell, 0).map do |peer|
      peer
    end
  end
  
  def row_peer_values(cell)
    find_peer_cells(cell, 1).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def column_peer_values(cell)
    find_peer_cells(cell, 0).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def square_peer_values(cell)
    find_peer_cells(cell, 2).map do |peer|
      @board[peer]
    end.delete_if {|num| num == 0}
  end

  def all_peer_values(cell)
    unique_peers(column_peer_values(cell) + square_peer_values(cell) + row_peer_values(cell))
  end

  def empty_cells
    @board.keys.inject([]) do |empty_cells, cell|
      empty_cells << cell if @board[cell] == 0 || @board[cell].nil?; empty_cells
    end
  end
  
  def empty_square_mates(designator)
    @board.keys.select do |cell|
      cell if cell[2] == designator && empty_cells.include?(cell)
    end
  end
  

  def cell_to_solve
    empty_cells.sort_by { |cell| all_peer_values(cell).length }.last
    empty_cells.each do |cell|
      puts "#{cell} has the following possibilities: #{possible_solutions(cell)}"
    end
  end

  def all_possible_numbers
    (1..9).to_a
  end
  
  # def account_for_pointing_peers(designator)
  #   solns = empty_square_mates(designator).map do |cell|
  #     possible_solutions(cell)
  #   end
  #   flappy = empty_square_mates(designator).zip(solns)
  #   meh = flappy.flatten.reject {|val| val.is_a?(String)}.uniq
  #   meh.each do |num|
  #     sister_cells = []
  #     flappy.each do |cell, values|
  #       if values.include?(num)
  #         sister_cells << cell
  #       end
  #     end
  #     if sister_cells.length == 2 && row_peers(sister_cells[0]).include?(sister_cells[1]) || column_peers(sister_cells[0]).include?(sister_cells[1])
  #       #####For this to work, cells need to be a class.
  #     end
  #   end
  # # binding.pry
  # end
  
  def possible_solutions_forreal(cell)
    possible_solutions(cell)
  end

  def possible_solutions(cell)
    all_possible_numbers.delete_if{ |num| all_peer_values(cell).include?(num) }
    #Remove pointing peers before returning possible solutions for cell
  end

  
###Begin heuristic that checks peers of empty cells in same designator group
###and solves cell if all other empty cells in the same group share a common peer
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

  ##There is a way better way to do this without a count, but I can't remember what it is...
  def check_peers(designator)
    needed = needed_numbers_for_group(designator)
    needed.length.times do
      count = 0
      all_empty_cells_for_group(designator).each do |cell|
        if all_peer_values(cell).include?(needed.last)
          count +=1
        end
      end
      if count == (all_empty_cells_for_group(designator).length - 1)
        solved_cell = all_empty_cells_for_group(designator).detect do |cell|
          !all_peer_values(cell).include?(needed.last)
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
      if possible_solutions(cell_to_solve).length == 1
        @board[cell_to_solve] = possible_solutions(cell_to_solve)[0]
      end
      check_them_all
      puts @board.values.select {|v| v==0}.length
    end
  end
end


puzzle_text = File.read("./puzzles/medium.txt")
solver = Solver.new(puzzle_text)
solver.account_for_pointing_peers('s')
