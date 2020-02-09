defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView

  def render(assigns), do: FramptonWeb.EditorView.render("show.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
