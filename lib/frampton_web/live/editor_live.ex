defmodule FramptonWeb.EditorLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div data-test="editor">
      <h1>Hello world!</h1>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
