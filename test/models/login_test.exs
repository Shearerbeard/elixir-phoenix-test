defmodule PhoenixTest.LoginTest do
  use PhoenixTest.ModelCase

  alias PhoenixTest.Login

  @valid_attrs %{password_hash: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Login.changeset(%Login{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Login.changeset(%Login{}, @invalid_attrs)
    refute changeset.valid?
  end
end
