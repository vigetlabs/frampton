defmodule FramptonWeb.EditorLiveTest do
  use FramptonWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Frampton.Post

  setup do
    {:ok, post_id} = Post.create
    [post_id: post_id]
  end

  test "the editor renders on initial page load", %{
    conn: conn, post_id: post_id
  } do
    conn = get(conn, "/editor/#{post_id}")
    assert html_response(conn, 200) =~ "data-test=\"editor\""
  end

  test "the editor renders live", %{
    conn: conn, post_id: post_id
  } do
    {:ok, _view, html} = live(conn, "/editor/#{post_id}")

    assert html =~ "editor-container"
  end

  test "when text is entered, it is rendered", %{
    conn: conn, post_id: post_id
  } do
    {:ok, view, _html} = live(conn, "/editor/#{post_id}")

    output = render_keydown(view, :render_post, %{"value" => "# Hello World!"})
             |> Floki.parse_document!
             |> Floki.find("div.rendered-output")
    assert output == [{"div", [{"class", "rendered-output"}],["\n# Hello World!  "]}]
  end
end
