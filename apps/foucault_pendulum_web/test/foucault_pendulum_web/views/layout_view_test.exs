defmodule FoucaultPendulumWeb.LayoutViewTest do
  use FoucaultPendulumWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  import Phoenix.HTML

  test "show SEO tags", %{conn: conn} do
    %{resp_body: body} = get(conn, "/")
    assert body =~ "meta name=\"description\""
    assert body =~ "meta name=\"keywords\""
    assert body =~ "og:type"
    assert body =~ "og:title"
    assert body =~ "og:description"
    assert body =~ "og:url"
  end
end
