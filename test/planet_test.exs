defmodule PlanetTest do
  use ExUnit.Case
  doctest Planet

  test "get basic gravity" do
    assert Planet.new().gravity == 9.8
  end
end
