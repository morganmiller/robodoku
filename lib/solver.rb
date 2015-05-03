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

  def possible_numbers
    (1..9).to_a
  end

  def compare_numbers(cell)
    possible_numbers.delete_if{ |num| peers(cell).include?(num) }
  end

  def peers(cell)
    peers = []
    @board.each do |other_key, other_val|
      peers << other_val if other_key.chars.any? {|spot| cell.include?(spot) }
    end
    peers.delete_if {|num| num == 0}.uniq
  end

  def empty_cells
    @board.keys.inject([]) do |empty_cells, cell|
      empty_cells << cell if @board[cell] == 0 || @board[cell].nil?; empty_cells
    end
  end

  def cell_to_solve
    empty_cells.sort_by { |cell| peers(cell).length }.last
  end

  def solved?
    !@board.values.include?(0)
  end

  def solve
    until solved?
      @board[cell_to_solve] = compare_numbers(cell_to_solve)
      puts "i'm solving!"
    end
  end

  # def find_peers_and_sub
  #   count = 0
  #   until count == 81
  #     @board.each do |key, val|
  #       if @board[key] != 0
  #         count += 1
  #       else
  #         if peers(key).length == 8
  #           peers(key).sort.each_with_index do |num, index|
  #             @board[key] = possible_numbers[index] if num != possible_numbers[index]
  #           end
  #         end
  #         count += 1
  #       end
  #     end
  #   end
  # end





  # parse into to_be_replaced_by_rows, column, square

  # coordinate system with a hash.... A1, A2, A3... to map a @board

  # know the value of a spot and/or if a spot is blank or not
  # know where each spot is on the board
  # find all of a spot's peers...
  # check to see if there is an easy solution
  # if not move on to check next open spot

  #For peers: Does each cell need to belong to a cell class?


end

class Cell

  def peers

  end

end


