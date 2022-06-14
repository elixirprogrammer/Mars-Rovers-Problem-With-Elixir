defmodule Rover do
  @moduledoc """
  Executes rover commands
  """

  @doc """
  Sets up the rover initial position state, then loops through commands list
  to execute each command, the modified state position is returned.
  """
  @spec move(instructions :: map()) :: struct()
  def move(instructions) do
    init_position =
      instructions.initial_position
      |> Enum.reduce(%Position{}, fn {key, value}, position ->
        Map.replace(position, key, value)
      end)

    instructions.commands
    |> Enum.reduce(
      init_position,
      fn command, position ->
        execute_command(command, position)
      end
    )
  end

  # Commands that matches when spinning left.
  defp execute_command("L", position) when position.direction == "N" do
    %{position | direction: "W"}
  end

  defp execute_command("L", position) when position.direction == "S" do
    %{position | direction: "E"}
  end

  defp execute_command("L", position) when position.direction == "E" do
    %{position | direction: "N"}
  end

  defp execute_command("L", position) when position.direction == "W" do
    %{position | direction: "S"}
  end

  # Commands that matches when spinning right.
  defp execute_command("R", position) when position.direction == "N" do
    %{position | direction: "E"}
  end

  defp execute_command("R", position) when position.direction == "S" do
    %{position | direction: "W"}
  end

  defp execute_command("R", position) when position.direction == "E" do
    %{position | direction: "S"}
  end

  defp execute_command("R", position) when position.direction == "W" do
    %{position | direction: "N"}
  end

  # Commands that matches when moving from its current spot.
  defp execute_command("M", position) when position.direction == "N" do
    %{position | y: position.y + 1}
  end

  defp execute_command("M", position) when position.direction == "S" do
    %{position | y: position.y - 1}
  end

  defp execute_command("M", position) when position.direction == "E" do
    %{position | x: position.x + 1}
  end

  defp execute_command("M", position) when position.direction == "W" do
    %{position | x: position.x - 1}
  end
end
