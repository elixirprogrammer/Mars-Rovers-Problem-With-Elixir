defmodule MarsTest do
  use ExUnit.Case

  test "simulates mission" do
    input = """
    5 5
    1 2 N
    LMLMLMLMM
    3 3 E
    MMRMMRMRRM
    """
    output = """
    1 3 N
    5 1 E
    """

    assert Mars.simulate_mission(input) == output
  end
end
