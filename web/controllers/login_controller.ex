defmodule PhoenixTest.LoginController do
  use PhoenixTest.Web, :controller

  alias PhoenixTest.Login
  alias PhoenixTest.User
  alias PhoenixTest.Session

  defp user_from_params(login_params) do
    changeset = User.changeset(%User{}, login_params)
    Repo.insert(changeset)
  end

  defp login_from_user(user, password) do
    params = %{:user_id => user.id, :password => password}
    changeset = Login.registration_changeset(%Login{}, params)
    Repo.insert(changeset)
  end

  defp session_from_user(user) do
    changeset = Session.registration_changeset(%Session{},
      %{:user_id => user.id})
    Repo.insert(changeset)
  end


  def create(conn, %{"name" => name,
                     "password" => password,
                     "bio" => bio,
                     "number_of_pets" => number_of_pets,
                    "email" => email}) do

    login_params = %{
      :name => name,
      :password => password,
      :bio => bio,
      :number_of_pets => number_of_pets,
      :email => email
    }

    result = Repo.transaction(fn ->
      with {:ok, user} <- user_from_params(login_params),
      {:ok, _} <- login_from_user(user, password),
      {:ok, session} <- session_from_user(user) do session
      else
        {:error, error_key} -> Repo.rollback(error_key)
      end
    end)

    case result do
      {:ok, session} ->
        conn
        |> put_status(:created)
        |> render("show.json", login: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixTest.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
