defmodule Calc do

  import Math

  defp init_values do
    %{
      pi: 3.14,
      gravity: 9.8,
      radius: 6_400_000.0,
      earth_angular_velocity: 729211.59,
      length: 67.0
    }
  end

  # TODO: add dialyzer
  def get_period(0.0) do
    :infinity 
  end

  def get_period(latitude) do
    %{pi: pi, earth_angular_velocity: w} = init_values()
    2 * pi / (w * sin(latitude))
    |> Float.round(10)
  end

  def get_position(l, t), do: get_position(:non_inertial, l, t)

  def get_position(:inertial, _l, t) do
    # Arbitrary Constants
    [a1, b1, a2, b2] = [1.0, 1.0, 1.0, 1.0]
    %{gravity: g, length: l} = init_values()

    x = a1 * sin(pow(g/l, 0.5) * t) + b1 * cos(pow(g/l, 0.5) * t)
    y = a2 * sin(pow(g/l, 0.5) * t) + b2 * cos(pow(g/l, 0.5) * t) 
    %{x: x, y: y}
  end

  def get_position(:non_inertial, l, t) do
    %{earth_angular_velocity: w_i} = init_values()
    %{x: x_i, y: y_i} = get_position(:inertial, l, t)

    w = w_i * sin(l)
    x = x_i * cos(w * t) + y_i * sin(w * t)
    y = -(x_i * sin(w * t)) + y_i * cos(w * t)
    %{x: x, y: y}
  end
end
