defmodule PhoenixTest.PageController do
  use PhoenixTest.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    page = %{title: "test"}
    render conn, "test.json", page: page
  end

  def tests(conn, _params) do
    list = [%{title: "test1"}, %{title: "test2"}]
    render conn, "tests.json", list: list
  end
end
