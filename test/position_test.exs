defmodule PositionTest do
  use ExUnit.Case

  setup do
    assert {:ok, _pid} = Position.start_link

    :ok
  end

  test "sets position struct" do
    assert %Position{x: nil, y: nil, direction: nil} = Position.get()
  end

  test "updates position" do
    position = %{x: 1, y: 1, direction: 5}
    Enum.each(position, fn {k, v} -> Position.update(k, v) end)

    assert %{x: 1, y: 1, direction: 5} = Position.get()
  end
end
