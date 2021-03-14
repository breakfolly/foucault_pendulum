defmodule FoucaultPendulumWeb.HealthCheckTest do
  use FoucaultPendulumWeb.ConnCase

  test "if request path is 'health_check', return 200 ok.", %{conn: conn} do
    conn = get(conn, "/health_check")
    assert json_response(conn, 200)["status"] == "ok"
  end
end
