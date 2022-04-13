defmodule Simulator do
  @moduledoc """
  Starts the mission simulation and returns the output.
  """

  @spec start_mission(input :: bitstring()) :: bitstring()
  def start_mission(input) do
    {:ok, _pid} = Position.start_link()

    chunk_input_string(input)
    |> get_instructions()
    |> Enum.map(&Rover.move(&1))
    |> get_output()
  end

  defp get_output(positions) do
    positions =
      positions
      |> Enum.map(&"#{&1.x} #{&1.y} #{&1.direction}")
      |> Enum.join("\n")

    positions <> "\n"
  end

  defp chunk_input_string(input) do
    input
    |> String.split("\n", trim: true)
    |> List.delete_at(0)
    |> Enum.chunk_every(2)
  end

  defp get_instructions(chunks) do
    chunks
    |> Enum.map(fn chunk ->
      map_instructions(chunk)
    end)
  end

  defp map_instructions(chunk) do
    initial_position = List.first(chunk)
    commands = List.last(chunk)
    init_pos_list = String.split(initial_position)

    cordinates = %{
      x: init_pos_list |> Enum.at(0) |> String.to_integer(),
      y: init_pos_list |> Enum.at(1) |> String.to_integer(),
      direction: init_pos_list |> Enum.at(2)
    }

    %{
      init_pos: cordinates,
      commands: commands |> String.split("", trim: true)
    }
  end
end
