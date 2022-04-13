defmodule Position do
  @moduledoc """
  This modules is define to start an agent to store the state of the position
  """
  use Agent

  # Defines struct with coordinates
  defstruct x: nil, y: nil, direction: nil

  def start_link() do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, &(&1))
  end

  def update(key, value) do
    Agent.update(__MODULE__, &(&1 |> Map.replace(key, value)))
  end
end
