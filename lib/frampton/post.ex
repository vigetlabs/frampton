defmodule Frampton.Post do
  use GenServer
  alias __MODULE__

  defstruct body: "", title: ""

  def render(%__MODULE{} = post, markdown) do
    html = Earmark.as_html!(markdown)
    {:ok, Map.put(post, :body, html)}
  end

  def create() do
    id = UUID.uuid1()

    {:ok, _pid} =
      DynamicSupervisor.start_child(Frampton.PostSupervisor, {Post, name: via(id)})
    {:ok, id}
  end

  def get(post_id) do
    {:ok, post} = GenServer.call(via(post_id), :read)
  end

  def update(post_id, %__MODULE{} = updated_post) do
    GenServer.call(via(post_id), {:update, updated_post})
  end

  defp via(id) do
    {:via, Registry, {Frampton.PostRegistry, id}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %Post{}, opts)
  end

  @impl true
  def init(post) do
    {:ok, post}
  end

  @impl true
  def handle_call({:update, post}, _from, state) do
    updated_post = struct(state, Map.from_struct(post))

    {:reply, {:ok, updated_post}, updated_post}
  end

  @impl true
  def handle_call(:read, _from, state) do
    {:reply, {:ok, state}, state}
  end

end
