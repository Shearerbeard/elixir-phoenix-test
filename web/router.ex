defmodule PhoenixTest.Router do
  use PhoenixTest.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  pipeline :authenticated do
    plug PhoenixTest.Plug.Authentication
  end

  scope "/", PhoenixTest do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController
    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
  end

  scope "/api", PhoenixTest, as: :api do
    pipe_through :api
    put "/login", LoginController, :create
    post "/session", SessionController, :update
    get "/hello/tests", PageController, :tests
    get "/hello/test", PageController, :test
    scope "/auth", Auth, as: :auth do
      pipe_through :authenticated
      get "/restricted", SelfController, :show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixTest do
  #   pipe_through :api
  # end
end
