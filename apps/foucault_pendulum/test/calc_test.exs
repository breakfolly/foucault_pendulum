defmodule FoucaultPendulum.CalcTest do
  use ExUnit.Case
  doctest FoucaultPendulum.Calc

  alias FoucaultPendulum.Calc

  describe "get_period/1" do
    test "at north pole" do
      assert 86164.01722311531 == Calc.get_period(pi() / 2.0)
    end

    test "at northern hemisphere" do
      assert 121_854.40258329792 == Calc.get_period(pi() / 4.0)
    end

    test "at equator" do
      assert :infinity == Calc.get_period(0.0)
    end

    test "at southern hemisphere" do
      assert 121_854.40258329792 == Calc.get_period(-(pi() / 4.0))
    end

    test "at south pole" do
      assert 86164.01722311531 == Calc.get_period(-(pi() / 2.0))
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
      p = Calc.get_period() / 2.0
      %{x: x, y: y} = Calc.get_position(:inertial, 0, p)
      assert %{x: 0.0, y: 0.0} == %{x: x |> Float.round(3), y: y |> Float.round(3)}
    end

    test "3/4 period" do
      p = Calc.get_period() * 3.0 / 4.0
      %{x: x, y: y} = Calc.get_position(:inertial, 0, p)
      assert %{x: -1.414, y: -1.414} == %{x: x |> Float.round(3), y: y |> Float.round(3)}
    end

    test "1 period" do
      p = Calc.get_period()
      %{x: x, y: y} = Calc.get_position(:inertial, 0, p)
      assert %{x: 0.0, y: 0.0} == %{x: x |> Float.round(3), y: y |> Float.round(3)}
    end
  end

  describe "get_postion in non-inertial coord" do
    # period in inertial coords
    @pi Calc.get_period()

    test "at north pole" do
      latitude = pi() / 2.0
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, 0.0)
      assert %{x: 1.4144, y: 1.414} == Calc.get_position(latitude, @pi / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi / 2.0)
      assert %{x: -1.4153, y: -1.4132} == Calc.get_position(latitude, @pi * 3.0 / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi)
    end

    test "at northern hemisphere" do
      latitude = pi() / 4.0
      assert %{x: 0.0, y: -0.0} == Calc.get_position(latitude, 0.0)
      assert %{x: 1.4144, y: 1.4141} == Calc.get_position(latitude, @pi / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi / 2.0)
      assert %{x: -1.415, y: -1.4135} == Calc.get_position(latitude, @pi * 3.0 / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi)
    end

    test "at equator" do
      assert Calc.get_position(:non_inertial, 0.0, 0.0) ==
               Calc.get_position(:inertial, 0.0, 0.0)
    end

    test "at southern hemisphere" do
      latitude = -pi() / 4.0
      assert %{x: 0.0, y: -0.0} == Calc.get_position(latitude, 0.0)
      assert %{x: 1.4141, y: 1.4144} == Calc.get_position(latitude, @pi / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi / 2.0)
      assert %{x: -1.4135, y: -1.415} == Calc.get_position(latitude, @pi * 3.0 / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi)
    end

    test "at south pole" do
      latitude = -pi() / 2.0
      assert %{x: 0.0, y: -0.0} == Calc.get_position(latitude, 0.0)
      assert %{x: 1.414, y: 1.4144} == Calc.get_position(latitude, @pi / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi / 2.0)
      assert %{x: -1.4132, y: -1.4153} == Calc.get_position(latitude, @pi * 3.0 / 4.0)
      assert %{x: 0.0, y: 0.0} == Calc.get_position(latitude, @pi)
    end
  end

  # TODO: make constants
  defp pi(), do: 3.14159
end
