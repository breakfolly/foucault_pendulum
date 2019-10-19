defmodule FoucaultPendulumTest do
  use ExUnit.Case
  doctest FoucaultPendulum

  test "greets the world" do
    assert FoucaultPendulum.hello() == :world
  end

  test "get longitude" do
    assert FoucaultPendulum.getLongitude() == 10
  end
end
