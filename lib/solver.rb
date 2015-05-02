require 'pry'


class Solver

  attr_reader :board

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
    @board = {}
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
    @board = final_designators.flatten.zip(split_data).to_h
  end

  def all_numbers
    (1..9).to_a
  end

  def find_peers_and_sub
    #needs to check for keys with matching values
    #find all of their values
    count = 0
    until count == 81
      @board.each do |key, val|
        require 'pry'
        binding.pry
        if @board[key] != 0
          count += 1
        else
          peers = []
          @board.each do |other_key, other_val|
            peers << other_val if other_key.chars.any? {|spot| key.include?(spot) }
          end
          peers.delete_if {|num| num == 0}
          if peers.uniq.length == 8
            peers.uniq.sort.each_with_index do |num, index|
              @board[key] = all_numbers[index] if num != all_numbers[index]
            end
          end
          count += 1
        end
      end
    end
  end




  # parse into to_be_replaced_by_rows, column, square

  # coordinate system with a hash.... A1, A2, A3... to map a @board

  # know the value of a spot and/or if a spot is blank or not
  # know where each spot is on the @board
  # find all of a spot's peers...
  # check to see if there is an easy solution
  # if not move on to check next open spot

  #For peers: Does each cell need to belong to a cell class?


end

class Cell

  def peers

  end

end


