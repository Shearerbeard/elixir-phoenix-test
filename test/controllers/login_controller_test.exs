defmodule PhoenixTest.LoginControllerTest do
  use PhoenixTest.ConnCase

  alias PhoenixTest.Login
  @valid_attrs %{password_hash: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, login_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    login = Repo.insert! %Login{}
    conn = get conn, login_path(conn, :show, login)
    assert json_response(conn, 200)["data"] == %{"id" => login.id,
      "user_id" => login.user_id,
      "password_hash" => login.password_hash}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, login_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, login_path(conn, :create), login: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Login, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, login_path(conn, :create), login: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    login = Repo.insert! %Login{}
    conn = put conn, login_path(conn, :update, login), login: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Login, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    login = Repo.insert! %Login{}
    conn = put conn, login_path(conn, :update, login), login: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    login = Repo.insert! %Login{}
    conn = delete conn, login_path(conn, :delete, login)
    assert response(conn, 204)
    refute Repo.get(Login, login.id)
  end
end
