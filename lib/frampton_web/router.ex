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

  pipeline :liveviews do
    plug :put_root_layout, {FramptonWeb.LayoutView, "live.html"}
  end

  scope "/", FramptonWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/editor", FramptonWeb do
    pipe_through [:browser, :liveviews]
    live "/", EditorLive
    live "/:post_id", EditorLive
  end
end
