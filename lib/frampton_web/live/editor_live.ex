defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Frampton.Post

  def render_raw(post) do
    # require IEx; IEx.pry
    post.body
  end

  def render_markdown(markdown) do
    markdown
    |> Earmark.as_html!
    |> raw
  end

  def handle_params(%{"post_id" => post_id}, _uri, socket) do
    :ok = Phoenix.PubSub.subscribe(Frampton.PubSub, post_id)
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
    ops = difference_to_operations(post.body, raw)
    require IEx; IEx.pry

    updated_post = Map.put(post, :body, raw)

    Post.update(post_id, updated_post)
    :ok = Phoenix.PubSub.broadcast(Frampton.PubSub, post_id, :update)

    {:noreply, assign(socket, post: updated_post)}
  end

  # transform the difference between two strings into OT operations
  def difference_to_operations(s1, s2) do
    String.myers_difference(s1, s2)
    |> Enum.map(fn {op, value} ->
      case op do
        :eq ->
          String.length(value)
        :ins ->
          %{i: value}
        :del ->
          %{d: value}
      end
    end) 
  end

  def handle_info(:update, socket) do
    {:noreply, assign_post(socket)}
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
