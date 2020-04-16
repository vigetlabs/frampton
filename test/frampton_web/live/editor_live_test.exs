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

    [
      {"div", _attrs, [
        {"h1", _rendered_attrs, ["Hello World!"]}
      ]}
    ] = render_keydown(view, :render_post, %{"value" => "# Hello World!"})
      |> Floki.parse_document!
      |> Floki.find("div.rendered-output")
  end

  test "when two editors are viewing the same post, they see the same rendered output", %{
    conn: conn, post_id: post_id
  } do
    {:ok, view_1, _html_1} = live(conn, "/editor/#{post_id}")
    render_keydown(view_1, :render_post, %{"value" => "# Hello World!"})

    {:ok, _view_2, html_2} = live(conn, "/editor/#{post_id}")
    [
      {"div", _attrs, [
        {"h1", _rendered_attrs, ["Hello World!"]}
      ]}
    ] = html_2
      |> Floki.parse_document!
      |> Floki.find("div.rendered-output")
  end

  test "when two editors are viewing the same post, they see the same raw input", %{
    conn: conn, post_id: post_id
  } do
    {:ok, view_1, _html_1} = live(conn, "/editor/#{post_id}")
    render_keydown(view_1, :render_post, %{"value" => "# Hello World!"})

    {:ok, _view_2, html_2} = live(conn, "/editor/#{post_id}")
    input_div = html_2
             |> Floki.parse_document!
             |> Floki.find("div.markdown-entry")

    assert input_div == [
      {"div", [{"class", "markdown-entry"}], [
        {"div",
          [
            {"contenteditable", "contenteditable"},
            {"phx-hook", "ContentEditable"}
          ],
          ["# Hello World!"]}
      ]}
    ]
  end
end
