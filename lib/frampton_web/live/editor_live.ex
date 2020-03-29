defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Frampton.Post

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
