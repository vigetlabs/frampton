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
end
