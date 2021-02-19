defmodule FoucaultPendulumWeb.PageLive do
  use FoucaultPendulumWeb, :live_view

  alias FoucaultPendulum.Calc

  @impl true
  def mount(_params, _session, socket) do
    time = 0
    degree = 90
    radian = Calc.degree_to_radian(degree)

    inertial_period = Calc.get_period()
    period = Calc.get_period(radian)
    %{x: x, y: y} = Calc.get_position(radian, time)

    s =
      socket
      |> assign(:time, time)
      |> assign(:degree, degree)
      |> assign(:period, period)
      |> assign(:inertial_period, inertial_period)
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
      Calc.degree_to_radian(degree)
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
