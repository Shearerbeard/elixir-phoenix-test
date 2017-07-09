defmodule PhoenixTest.Auth.SelfView do
  use PhoenixTest.Web, :view

  def render("show.json", %{self: self}) do
    %{data: render_one(self, PhoenixTest.Auth.SelfView, "self.json")}
  end

  def render("self.json", %{self: self}) do
    %{id: self.id,
      name: self.name}
  end

end
