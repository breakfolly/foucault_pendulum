defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "get basic gravity" do
    assert Calc.get_init().gravity == 9.8
  end
end
