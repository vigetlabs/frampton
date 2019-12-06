defmodule Frampton.PostTest do
  use ExUnit.Case, async: true
  alias Frampton.Post

  describe "render/2" do
    test "returns our post with the body set" do
      markdown = "# Hello World!"
      assert Post.render(%Post{}, markdown) == {:ok, %Post{body: "<h1>Hello World!</h1>\n"}}
    end
  end
end
