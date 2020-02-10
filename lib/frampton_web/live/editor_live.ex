defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView
  alias Frampton.Post

  def render(assigns), do: FramptonWeb.EditorView.render("show.html", assigns)

  def mount(_params, _session, socket) do
    post = %Post{}
    {:ok, assign(socket, post: post)}
  end

  def handle_event(
    "render_post",
    %{"value" => raw},
    %{assigns: %{post: post}} = socket
  ) do
    {:ok, post} = Post.render(post, raw)

    {:noreply, assign(socket, post: post)}
  end
end
