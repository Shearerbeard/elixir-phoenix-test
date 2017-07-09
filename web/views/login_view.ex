defmodule PhoenixTest.LoginView do
  use PhoenixTest.Web, :view

  def render("index.json", %{logins: logins}) do
    %{data: render_many(logins, PhoenixTest.LoginView, "login.json")}
  end

  def render("show.json", %{login: login}) do
    %{data: render_one(login, PhoenixTest.LoginView, "login.json")}
  end

  def render("login.json", %{login: login}) do
    %{id: login.id,
      user_id: login.user_id,
      token: login.token}
      # password_hash: login.password_hash}
  end
end
