defmodule FramptonWeb.EditorLiveTest do
  use FramptonWeb.ConnCase
  import Phoenix.LiveViewTest

  test "the editor renders on initial page load", %{conn: conn} do
    conn = get(conn, "/editor")
    assert html_response(conn, 200) =~ "data-test=\"editor\""
  end

  test "the editor renders live", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/editor")

    assert html =~ "editor-container"
  end

  test "when text is entered, it is rendered", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/editor")

    [
      {"div", _attrs, [
        {"h1", _rendered_attrs, ["Hello World!"]}
      ]}
    ] = render_keydown(view, :render_post, %{"value" => "# Hello World!"})
      |> Floki.parse_document!
      |> Floki.find("div.rendered-output")
  end
end
