defmodule FramptonWeb.Router do
  use FramptonWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FramptonWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/editor", EditorLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", FramptonWeb do
  #   pipe_through :api
  # end
end
