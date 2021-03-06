defmodule FoucaultPendulum.Calc do
  import Math

  @spec init_values() :: map()
  defp init_values do
    %{
      pi: 3.14159,
      gravity: 9.8,
      radius: 6_400_000.0,
      earth_angular_velocity: 7.2921159e-5,
      length: 67.0
    }
  end

  @spec get_period() :: float()
  def get_period() do
    # initial coord
    %{pi: pi, gravity: g, length: l} = init_values()
    2 * pi * pow(l / g, 0.5)
  end

  @spec get_period(float()) :: atom() | float()
  def get_period(0.0) do
    # at equator
    :infinity
  end

  def get_period(latitude) do
    %{pi: pi, earth_angular_velocity: w} = init_values()
    2 * pi / (w * sin(latitude))
    |> abs()
  end

  @spec get_position(float(), integer()) :: map()
  def get_position(l, t), do: get_position(:non_inertial, l, t)

  @spec get_position(atom(), float(), integer()) :: map()
  def get_position(:inertial, _latitude, t) do
    # Arbitrary Constants
    [a1, b1, a2, b2] = [1.0, 1.0, 1.0, 1.0]
    %{gravity: g, length: l} = init_values()

    # Constants for period (by gravity, length)
    c = 2.05359140961
    tp = t - c
    x = a1 * sin(pow(g / l, 0.5) * tp) + b1 * cos(pow(g / l, 0.5) * tp)
    y = a2 * sin(pow(g / l, 0.5) * tp) + b2 * cos(pow(g / l, 0.5) * tp)
    %{x: x, y: y}
  end

  def get_position(:non_inertial, 0.0, t) do
    # at equator
    get_position(:inertial, 0.0, t)
  end

  def get_position(:non_inertial, l, t) do
    %{earth_angular_velocity: w_i} = init_values()
    %{x: x_i, y: y_i} = get_position(:inertial, l, t)

    # Constants for period (by gravity, length)
    c = 2.05359140961
    tp = t - c

    w = w_i * sin(l)
    x = (x_i * cos(w * tp) + y_i * sin(w * tp)) |> Float.round(4)
    y = (-(x_i * sin(w * tp)) + y_i * cos(w * tp)) |> Float.round(4)
    %{x: x, y: y}
  end
end
