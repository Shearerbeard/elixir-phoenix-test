defmodule PhoenixTest.PageView do
  use PhoenixTest.Web, :view

  def render("test.json", %{page: page}) do
    %{stuff: page.title}
  end

  def render("tests.json", %{list: list}) do
    %{data: render_many(list, PhoenixTest.PageView, "test.json")}
  end

end
