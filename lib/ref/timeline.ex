defmodule Ref.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users.User

  alias Ref.Timeline.Post
  alias Ref.Timeline.Comment

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.id])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  def get_post_comments(id) do
    Repo.all(from c in Comment, where: (c.post_id == ^id))
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  def inc_likes(%Post{id: id}, user_id) do
    get_post = get_post!(id)
    likes_list = String.split(get_post.likes_count, " ")
    if user_id not in likes_list do
      {1, [post]} =
      from(p in Post, where: p.id == ^id, select: p)
      |> Repo.update_all(set: [likes_count: "#{get_post.likes_count}" <> " " <> "#{user_id}"])
    broadcast({:ok, post}, :post_updated)
    end
    if user_id in String.split(get_post.likes_count," ") do
      {1, [post]} =
      from(p in Post, where: p.id == ^id, select: p)
      |> Repo.update_all(set: [likes_count: List.delete(likes_list, user_id) |> Enum.join])
    broadcast({:ok, post}, :post_updated)
    end

  end
  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Ref.PubSub, "posts")
  end
  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Ref.PubSub, "posts", {event, post})
    {:ok, post}
  end

  #comment functions

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

end
