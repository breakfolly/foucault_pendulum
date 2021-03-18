defmodule FoucaultPendulumWeb.PageLiveTest do
  use FoucaultPendulumWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Foucault Pendulum"
    assert render(page_live) =~ "Latitude"
    assert render(page_live) =~ "Current"
    assert render(page_live) =~ "Pantheon"
  end
end
