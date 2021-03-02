defmodule FoucaultPendulumWeb.PageLive do
  use FoucaultPendulumWeb, :live_view

  alias FoucaultPendulum.Calc

  @impl true
  def mount(_params, _session, socket) do
    # from css
    earth_radius = 150

    degree = 90
    radian = Math.deg2rad(degree)
    pole_width = (earth_radius * Math.cos(radian)) |> Float.ceil() |> max(3)
    pole_height = (earth_radius * Math.sin(radian)) |> Float.ceil() |> max(3)

    time = 0
    inertial_period = Calc.get_period()
    period = Calc.get_period(radian)

    %{x: x, y: y} = Calc.get_position(radian, time)

    s =
      socket
      # Latitude Data
      |> assign(:degree, degree)
      |> assign(:radian, radian)
      |> assign(:pole_width, pole_width)
      |> assign(:pole_height, pole_height)
      # Current Data
      |> assign(:time, time)
      |> assign(:period, period)
      |> assign(:inertial_period, inertial_period)
      # Pantheon Data
      |> assign(:x, x)
      |> assign(:y, y)

    :timer.send_interval(1000, self(), :next_time)
    {:ok, s}
  end

  @impl true
  def handle_info(:next_time, socket) do
    time = socket.assigns.time + 1000
    degree = socket.assigns.degree

    %{x: x, y: y} =
      Math.deg2rad(degree)
      |> Calc.get_position(time)

    s =
      socket
      |> assign(:time, time)
      |> assign(:degree, degree)
      |> assign(:x, x)
      |> assign(:y, y)

    {:noreply, s}
  end
end
