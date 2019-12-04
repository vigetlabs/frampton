defmodule FramptonWeb.PageController do
  use FramptonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
