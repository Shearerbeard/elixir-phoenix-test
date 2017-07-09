defmodule PhoenixTest.LoginController do
  use PhoenixTest.Web, :controller

  alias PhoenixTest.Login
  alias PhoenixTest.User
  alias PhoenixTest.Session

  # def index(conn, _params) do
  #   logins = Repo.all(Login)
  #   render(conn, "index.json", logins: logins)
  # end

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
        |> put_resp_header("location", api_login_path(conn, :show, session.id))
        |> render("show.json", login: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixTest.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    login = Repo.get!(Session, id)
    render(conn, "show.json", login: login)
  end

  # def update(conn, %{"id" => id, "login" => login_params}) do
  #   login = Repo.get!(Login, id)
  #   changeset = Login.changeset(login, login_params)

  #   case Repo.update(changeset) do
  #     {:ok, login} ->
  #       render(conn, "show.json", login: login)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(PhoenixTest.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   login = Repo.get!(Login, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(login)

  #   send_resp(conn, :no_content, "")
  # end
end
