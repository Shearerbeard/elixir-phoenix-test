defmodule PhoenixTest.SessionView do
  use PhoenixTest.Web, :view

  def render("show.json", %{session: session}) do
    %{data: render_one(session, PhoenixTest.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      user_id: session.user_id,
      token: session.token}
  end
end
