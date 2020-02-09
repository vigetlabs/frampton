defmodule FrmaptonWeb.EditorLiveTest do
  use FramptonWeb.ConnCase
  import Phoenix.LiveViewTest

  test "the editor renders" do
    conn = get(build_conn(), "/editor")
    assert html_response(conn, 200) =~ "data-test=\"editor\""
  end
end
