require_relative 'cell'

class Board

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
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
    final_designators.flatten.map.with_index do |designator, index|
      Cell.new(split_data[index], designator)
    end
  end
end
