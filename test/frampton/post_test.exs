defmodule Frampton.PostTest do
  use ExUnit.Case, async: true
  alias Frampton.Post

  describe "create/0" do
    test "returns a new post with a unique id" do
      {:ok, id} = Post.create()
      {:ok, info} = UUID.info(id)

      # This is probably a silly test
      assert info[:variant] == :rfc4122
    end
  end

  describe "get/1" do
    test "with a valid id retrieves the correct post" do
      {:ok, id} = Post.create()
      {:ok, post} = Post.get(id)
      assert post == %Post{body: "", title: ""}
    end

    test "when given a non-existant id, crashes" do
      {:noproc, {GenServer, :call, _via}} = catch_exit(Post.get(12345))
    end
  end

  describe "update/2" do
    test "with a valid post_id, updates the post" do
      {:ok, id} = Post.create()
      {:ok, updated_post} = Post.update(id, %{title: "New Title who dis?"})

      assert updated_post.title =~ "New Title"
    end
  end
end
