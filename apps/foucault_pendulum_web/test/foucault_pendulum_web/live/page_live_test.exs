defmodule FoucaultPendulumWeb.PageLiveTest do
  use FoucaultPendulumWeb.ConnCase

  alias FoucaultPendulum.Calc
  alias FoucaultPendulumWeb.Live.Util

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Foucault Pendulum"
    assert render(page_live) =~ "Latitude"
    assert render(page_live) =~ "Current"
    assert render(page_live) =~ "Pantheon"
  end

  test "change degree", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    time = 100
    degree = 60
    radian = Math.deg2rad(degree)
    ip = Calc.get_period()
    p = Calc.get_period(radian)

    %{pole_width: pw, pole_height: ph} = Util.degree2pole(degree)

    send(view.pid, :next_time)
    rendered_html = view |> element("form#degree_form") |> render_change(%{degree: degree})

    assert rendered_html =~ "Time : #{time}"
    assert rendered_html =~ "Inertial Period : #{ip |> Float.round(3)}"
    assert rendered_html =~ "Period : #{p |> Float.round(3)}"
    assert rendered_html =~ "width:#{pw}px; height:#{ph}px"

    # TODO: add test position in pantheon
    #    assert rendered_html =~ "x : #{x |> Float.round(4)}" 
    #    assert rendered_html =~ "y : #{y |> Float.round(4)}" 
  end
end
