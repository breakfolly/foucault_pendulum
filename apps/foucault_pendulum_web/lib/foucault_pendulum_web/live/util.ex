defmodule FoucaultPendulumWeb.Live.Util do
  # from css
  def earth_radius(), do: 150

  def degree2pole(degree) do
    radian = Math.deg2rad(degree)
    pole_width = (earth_radius() * Math.cos(radian)) |> Float.ceil() |> max(4)
    pole_height = (earth_radius() * Math.sin(radian)) |> Float.ceil() |> abs() |> max(4)
    %{pole_width: pole_width, pole_height: pole_height}
  end
end
