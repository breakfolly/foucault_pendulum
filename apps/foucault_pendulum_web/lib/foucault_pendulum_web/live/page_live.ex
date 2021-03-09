defmodule FoucaultPendulumWeb.PageLive do
  use FoucaultPendulumWeb, :live_view

  alias FoucaultPendulum.Calc

  # from css
  defp earth_radius(), do: 150

  @impl true
  def mount(params, _session, socket) do
    degree = Map.get(params, "degree", "45") |> String.to_integer()
    radian = Math.deg2rad(degree)
    latitute = Map.merge(%{degree: degree, radian: radian}, degree2pole(degree))

    time = 0
    inertial_period = Calc.get_period()
    period = Calc.get_period(radian)

    %{x: x, y: y} = Calc.get_position(radian, time)
    pantheon2d = Poison.encode!([Calc.get_position(radian, time)])

    s =
      assign_latitute(socket, latitute)

      # Current Data
      |> assign(:time, time)
      |> assign(:period, period)
      |> assign(:inertial_period, inertial_period)

      # Pantheon Data
      |> assign(:x, x)
      |> assign(:y, y)
      |> assign(:xy, Poison.encode!(%{x: x, y: y}))
      |> assign(:pantheon2d, pantheon2d)

    :timer.send_interval(1000, self(), :next_time)
    {:ok, s}
  end

  @impl true
  def handle_info(:next_time, socket) do
    time = socket.assigns.time + 100
    degree = socket.assigns.degree

    p =
      (socket.assigns.pantheon2d |> Poison.decode!()) ++
        [Math.deg2rad(degree) |> Calc.get_position(time)]

    %{x: x, y: y} =
      Math.deg2rad(degree)
      |> Calc.get_position(time)

    s =
      socket
      |> assign(:time, time)
      |> assign(:degree, degree)
      |> assign(:x, x)
      |> assign(:y, y)
      |> assign(:xy, Poison.encode!(%{x: x, y: y}))
      |> assign(:pantheon2d, Poison.encode!(p))

    {:noreply, s}
  end

  @impl true
  def handle_event("new_degree", param, socket) do
    degree = Map.get(param, "degree", "45") |> String.to_integer()
    radian = Math.deg2rad(degree)
    latitute = Map.merge(%{degree: degree, radian: radian}, degree2pole(degree))
    {:noreply, assign_latitute(socket, latitute)}
  end

  defp degree2pole(degree) do
    radian = Math.deg2rad(degree)
    pole_width = (earth_radius() * Math.cos(radian)) |> Float.ceil() |> max(3)
    pole_height = (earth_radius() * Math.sin(radian)) |> Float.ceil() |> abs() |> max(3)
    %{pole_width: pole_width, pole_height: pole_height}
  end

  defp assign_latitute(socket, latitute) do
    %{degree: degree, radian: radian, pole_width: pole_width, pole_height: pole_height} = latitute

    socket
    |> assign(:degree, degree)
    |> assign(:radian, radian)
    |> assign(:pole_width, pole_width)
    |> assign(:pole_height, pole_height)
  end
end
