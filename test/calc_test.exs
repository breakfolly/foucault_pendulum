defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  describe "get_period/1" do
    test "at north pole" do
      assert 8.612e-6 == Calc.get_period(pi() / 2.0)
    end

    test "at northern hemisphere" do
    end

    test "at equator" do
      assert :infinity == Calc.get_period(0.0) 
    end

    test "at southern hemisphere" do
    end
   
    test "at south pole" do
      assert -8.612e-6 == Calc.get_period(-(pi() / 2.0))
    end
  end

  describe "get_postion in inertial coord" do
    test "0s" do
      assert %{x: 1.0, y: 1.0} = Calc.get_position(:inertial, 0, 0)
    end

    test "1/4 period" do
    end
 
    test "1/2 period" do
    end

    test "1 period" do
    end
  end

  describe "get_postion in non-inertial coord" do
  end

  defp pi(), do: 3.14
end
