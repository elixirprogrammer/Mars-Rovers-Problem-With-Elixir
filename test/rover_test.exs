defmodule RoverTest do
  use ExUnit.Case

  setup do
    assert {:ok, _pid} = Position.start_link()

    instructions = %{
      initial_position: %{x: 0, y: 0, direction: "N"},
      commands: []
    }

    %{instructions: instructions}
  end

  test "rover moves doesn't move", %{instructions: instructions} do
    assert %Position{x: 0, y: 0, direction: "N"} = Rover.move(instructions)
  end

  test "rover spins west", %{instructions: instructions} do
    instructions = %{instructions | commands: ["L"]}
    assert %Position{x: 0, y: 0, direction: "W"} = Rover.move(instructions)
  end

  test "rover moves 1 step east", %{instructions: instructions} do
    instructions = %{instructions | commands: ["R", "M"]}

    assert %Position{x: 1, y: 0, direction: "E"} = Rover.move(instructions)
  end
end
