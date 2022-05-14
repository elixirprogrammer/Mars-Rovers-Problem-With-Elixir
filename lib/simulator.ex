defmodule Simulator do
  @moduledoc """
  Starts the mission simulation and returns the output.
  """

  @spec start_mission(input :: bitstring()) :: bitstring()
  def start_mission(input) do
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

  # Converts input to list chunked by 2 removing first position of list
  # Position 0 at each chunked list inside is the initial position and at the second position is the instructions.
  # Examples:
  # iex> input = """
  # 5 5
  # 1 2 N
  # LMLMLMLMM
  # 3 3 E
  # MMRMMRMRRM
  # """
  # iex> chunk_input_string(input)
  # [["1 2 N", "LMLMLMLMM"], ["3 3 E", "MMRMMRMRRM"]]
  @spec chunk_input_string(input :: bitstring()) :: list()
  defp chunk_input_string(input) do
    input
    |> String.split("\n", trim: true)
    |> List.delete_at(0)
    |> Enum.chunk_every(2)
  end

  # Loops through each chunked list and gets a map with initial position and
  # coordinates, then returns a list of maps
  # Examples:
  # iex> chunks = [["1 2 N", "LMLMLMLMM"], ["3 3 E", "MMRMMRMRRM"]]
  # iex> get_instructions(chunks)
  # [
  #   %{
  #     initial_position: %{x: 1, y: 2, direction: "N"},
  #     commands: ["L", "M", "L", "M", "L", "M", "L", "M", "M"]
  #   },
  #   %{
  #     initial_position: %{x: 3, y: 3, direction: "E"},
  #     commands: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]
  #   }
  # ]
  @spec get_instructions(chunks :: list()) :: list()
  defp get_instructions(chunks) do
    chunks
    |> Enum.map(fn chunk ->
      map_instructions(chunk)
    end)
  end

  # Takes a chunked list with the initial position and instructions
  # Maps the initial position with x, y, coordinates and direction
  # Returns a map with initial position coordinates and instructions or commands
  # Commands is a list with all instructions
  # Examples:
  # iex> chunk = ["3 3 E", "MMRMMRMRRM"]
  # iex> map_instructions(chunk)
  # %{
  #  initial_position: %{x: 3, y: 3, direction: "E"},
  #  commands: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]
  # }
  @spec map_instructions(chunk :: list()) :: map()
  defp map_instructions(chunk) do
    initial_position = List.first(chunk)
    commands = List.last(chunk)
    init_pos_list = String.split(initial_position)

    coordinates = %{
      x: init_pos_list |> Enum.at(0) |> String.to_integer(),
      y: init_pos_list |> Enum.at(1) |> String.to_integer(),
      direction: init_pos_list |> Enum.at(2)
    }

    %{
      initial_position: coordinates,
      commands: commands |> String.split("", trim: true)
    }
  end
end
