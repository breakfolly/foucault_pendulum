defmodule FoucaultPendulumWeb.PageLiveTest do
  use FoucaultPendulumWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    # TODO : add test html loading
    #    assert disconnected_html =~ "Welcome to Phoenix!"
    #    assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
