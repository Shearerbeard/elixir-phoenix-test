defmodule PhoenixTest.Auth.SelfController do
  use PhoenixTest.Web, :controller

  def show(conn, _) do
    self = conn.assigns.current_user
    render(conn, "show.json", self: self)
  end
end
