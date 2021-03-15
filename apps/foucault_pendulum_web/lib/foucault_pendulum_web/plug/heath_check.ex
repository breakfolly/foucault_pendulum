defmodule FoucaultPendulumWeb.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health_check"} = conn, _opts) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, "{\"status\": \"ok\"}")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
