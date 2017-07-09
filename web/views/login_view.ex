defmodule PhoenixTest.LoginView do
  use PhoenixTest.Web, :view

  def render("show.json", %{login: login}) do
    %{data: render_one(login, PhoenixTest.LoginView, "login.json")}
  end

  def render("login.json", %{login: login}) do
    %{id: login.id,
      user_id: login.user_id,
      token: login.token}
  end
end
