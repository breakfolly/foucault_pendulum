defmodule FoucaultPendulumWeb.PageLive do
  use FoucaultPendulumWeb, :live_view

  alias FoucaultPendulum.Calc
  alias FoucaultPendulumWeb.Live.Util

  @impl true
  def mount(params, _session, socket) do
    degree = Map.get(params, "degree", "45") |> String.to_integer()
    radian = Math.deg2rad(degree)

    latitute =
      %{degree: degree, radian: radian}
      |> Map.merge(Util.degree2pole(degree))

    time = 0
    current = get_current(time, radian)
    pantheon = Calc.get_position(radian, time)

    socket =
      assign_latitute(socket, latitute)
      |> assign_current(current)
      |> assign_pantheon(pantheon)

    :timer.send_interval(1000, self(), :next_time)
    {:ok, socket}
  end

  @impl true
  def handle_info(:next_time, socket) do
    time = socket.assigns.time + 100
    degree = socket.assigns.degree

    pantheon =
      Math.deg2rad(degree)
      |> Calc.get_position(time)

    s =
      socket
      |> assign(:time, time)
      |> assign(:degree, degree)
      |> assign_pantheon(pantheon)

    {:noreply, s}
  end

  @impl true
  def handle_event("new_degree", param, socket) do
    degree = Map.get(param, "degree", "45") |> String.to_integer()
    radian = Math.deg2rad(degree)
    latitute = Map.merge(%{degree: degree, radian: radian}, Util.degree2pole(degree))
    current = get_current(socket.assigns.time, radian)

    {:noreply, assign_latitute(socket, latitute) |> assign_current(current)}
  end

  defp get_current(time, radian),
    do: %{time: time, inertial_period: Calc.get_period(), period: Calc.get_period(radian)}

  defp assign_latitute(socket, latitute) do
    %{degree: degree, radian: radian, pole_width: pole_width, pole_height: pole_height} = latitute

    socket
    |> assign(:degree, degree)
    |> assign(:radian, radian)
    |> assign(:pole_width, pole_width)
    |> assign(:pole_height, pole_height)
  end

  defp assign_current(socket, current) do
    %{time: time, inertial_period: inertial_period, period: period} = current

    socket
    |> assign(:time, time)
    |> assign(:period, if(period == :infinity, do: period, else: Float.round(period, 3)))
    |> assign(:inertial_period, Float.round(inertial_period, 3))
  end

  defp assign_pantheon(socket, pantheon) do
    %{x: x, y: y} = pantheon

    socket
    |> assign(:x, x |> Float.round(4))
    |> assign(:y, y |> Float.round(4))
    |> assign(:xy, Poison.encode!(%{x: x, y: y}))
  end
end
