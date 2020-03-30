defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Frampton.Post

  def handle_params(%{"post_id" => post_id}, _uri, socket) do
    {:noreply, assign_post(socket, post_id)}
  end

  def handle_params(_params, _uri, socket) do
    {:ok, post_id} = Post.create
    path = FramptonWeb.Router.Helpers.live_path(socket, FramptonWeb.EditorLive, post_id)
    {:noreply, push_patch(socket, to: path)}
  end

  def handle_event(
    "render_post",
    %{"value" => raw},
    %{assigns: %{post_id: post_id, post: post}} = socket
  ) do
    {:ok, updated_post} = Post.render(post, raw)
    Post.update(post_id, updated_post)

    {:noreply, assign(socket, post: updated_post)}
  end

  defp assign_post(socket, post_id) do
    socket
    |> assign(post_id: post_id)
    |> assign_post()
  end

  defp assign_post(%{assigns: %{post_id: post_id}} = socket) do
    {:ok, post} = Post.get(post_id)
    assign(socket, post: post)
  end
end
