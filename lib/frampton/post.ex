defmodule Frampton.Post do
  defstruct body: "", title: ""

  def render(%__MODULE{} = post, markdown) do
    html = Earmark.as_html!(markdown)
    {:ok, Map.put(post, :body, html)}
  end
end
