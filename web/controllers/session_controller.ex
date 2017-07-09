defmodule PhoenixTest.SessionController do
  use PhoenixTest.Web, :controller

  alias PhoenixTest.Login
  alias PhoenixTest.User
  alias PhoenixTest.Session

  import Comeonin.Bcrypt, only: [checkpw: 2]

  def update(conn, %{"email" => email, "password" => password}) do
    result = Repo.transaction(fn ->
      with user <- Repo.get_by(User, email: email),
      true <- !is_nil(user),
      login <- Repo.get_by(Login, user_id: user.id),
      true <- checkpw(password, login.password_hash),
      {:ok, session} <-
        Repo.insert(Session.registration_changeset(%Session{},
            %{:user_id => user.id}))
      do session
      else
        {:error, error_key} -> Repo.rollback(error_key)
        _ -> Repo.rollback(:unauthorized)
      end
    end)

    case result do
      {:ok, session} ->
        conn
        |> put_status(:ok)
        |> render("show.json", session: session)
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", %{})
      {:error, changeset} ->
        conn
        |> put_status(:unauthorized)
        |> render(PhoenixTest.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
