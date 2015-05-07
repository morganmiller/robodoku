require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'

class CellTest < Minitest::Test
  attr_reader :cell
  
  def setup
    @cell = Cell.new(0, 'a1z')
  end
  
  def test_it_parses_designator_information
    assert_equal '1', cell.row
    assert_equal 'a', cell.column
    assert_equal 'z', cell.square
  end

  def test_it_can_change_its_solution
    assert_equal 0, cell.solution
    cell.solution = 4
    assert_equal 4, cell.solution
  end

  def test_it_knows_solved_status
    refute cell.solved?
    cell.solution = 5
    assert cell.solved?
  end
end
