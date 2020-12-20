defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  describe "get_period/1" do
    test "at north pole" do
      assert 8.6164e-6 == Calc.get_period(pi() / 2.0)
    end

    test "at northern hemisphere" do
      assert 1.21854e-5 == Calc.get_period(pi() / 4.0)
    end

    test "at equator" do
      assert :infinity == Calc.get_period(0.0) 
    end

    test "at southern hemisphere" do
      assert -1.21854e-5 == Calc.get_period(-(pi() / 4.0))
    end
   
    test "at south pole" do
      assert -8.6164e-6 == Calc.get_period(-(pi() / 2.0))
    end
  end

  describe "get_postion in inertial coord" do
    test "0s" do
      %{x: x, y: y} = Calc.get_position(:inertial, 0, 0)
      assert %{x: 0.0, y: 0.0} == %{x: x |> Float.round(3), y: y |> Float.round(3)} 
    end

    test "1/4 period" do
      p = Calc.get_period() / 4.0
      %{x: x, y: y} = Calc.get_position(:inertial, 0, p)
      assert %{x: 1.414, y: 1.414} == %{x: x |> Float.round(3), y: y |> Float.round(3)} 
    end
 
    test "1/2 period" do
    end

    test "1 period" do
      p = Calc.get_period()
      %{x: x, y: y} = Calc.get_position(:inertial, 0, p)
      assert %{x: 0.0, y: 0.0} == %{x: x |> Float.round(3), y: y |> Float.round(3)} 
    end
  end

  describe "get_postion in non-inertial coord" do
  end

  # TODO: make constants
  defp pi(), do: 3.14159
end
