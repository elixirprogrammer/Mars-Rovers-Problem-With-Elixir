defmodule Rover do
  @moduledoc """
  Executes rover commands
  """
  require Logger

  @doc """
  Sets up the rover initial position state, then loops through commands list
  to execute each command, the modified state position is returned.
  """
  @spec move(instructions :: map()) :: struct()
  def move(instructions) do
    :ok = instructions.init_pos |> Enum.each(fn {k, v} -> Position.update(k, v) end)

    instructions.commands
    |> Enum.each(
      &execute_command(
        &1
        |> String.downcase()
        |> String.to_atom(),
        Position.get().direction
      )
    )

    Position.get()
  end

  # Commands that matches when spinning left.
  defp execute_command(:l, direction) when direction == "N" do
    :ok = Position.update(:direction, "W")
  end
  defp execute_command(:l, direction) when direction == "S" do
    :ok = Position.update(:direction, "E")
  end
  defp execute_command(:l, direction) when direction == "E" do
    :ok = Position.update(:direction, "N")
  end
  defp execute_command(:l, direction) when direction == "W" do
    :ok = Position.update(:direction, "S")
  end

  # Commands that matches when spinning right.
  defp execute_command(:r, direction) when direction == "N" do
    :ok = Position.update(:direction, "E")
  end
  defp execute_command(:r, direction) when direction == "S" do
    :ok = Position.update(:direction, "W")
  end
  defp execute_command(:r, direction) when direction == "E" do
    :ok = Position.update(:direction, "S")
  end
  defp execute_command(:r, direction) when direction == "W" do
    :ok = Position.update(:direction, "N")
  end

  # Commands that matches when moving from its current spot.
  defp execute_command(:m, direction) when direction == "N" do
    %{y: y} = Position.get()
    :ok = Position.update(:y, y + 1)
  end
  defp execute_command(:m, direction) when direction == "S" do
    %{y: y} = Position.get()
    :ok = Position.update(:y, y - 1)
  end
  defp execute_command(:m, direction) when direction == "E" do
    %{x: x} = Position.get()
    :ok = Position.update(:x, x + 1)
  end
  defp execute_command(:m, direction) when direction == "W" do
    %{x: x} = Position.get()
    :ok = Position.update(:x, x - 1)
  end

  # Default match when no valid command, error is logged.
  defp execute_command(m, _direction) do
    Logger.error("Command: #{m} not allowed.")
  end
end
