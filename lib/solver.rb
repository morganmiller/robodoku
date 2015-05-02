require 'pry'


class Solver


  LETTERMAP = ("a".."i").to_a

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
  end

  def split_data
    @puzzle_text.split("\n").map(&:chars).flatten
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


  def board
    letters = ("a".."i").to_a
    row = ["x"] * 9
    letters_to_sub = letters.zip(row).map(&:join)
    positions = []
    9.times do |time|
      positions << letters_to_sub.map do |pair|
        pair.gsub('x', (time+1).to_s)
      end
    end
    final_positions = positions.flatten.zip(squares).map(&:join).map {|x| x = Cell.new}
    final_positions.flatten.zip(split_data).to_h
  end


  # def output_data
  #   @puzzle_text
  #   LETTERMAP
  # end

  # parse into row, column, square

  # coordinate system with a hash.... A1, A2, A3... to map a board

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

























#
# def make_board
#   letters = ("a".."i").to_a
#   numbers = (1..9).to_a
#   board = []
#   index_counter = 0
#   9.times do
#     x = letters[index_counter]
#     index_counter += 1
#     row = [x,x,x,x,x,x,x,x,x]
#     row.zip(numbers)
#     board << row
#   end
#   p board
# end
