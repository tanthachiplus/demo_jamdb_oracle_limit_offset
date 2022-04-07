defmodule UserService do
  import Ecto.Query, warn: false
  alias DemoJamdbOracleLimitOffset.Repo


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """

  def list_users(criteria \\ %{}) do

    query =
      from(u in Users)
      |> order_by(:id)

    page =
      (criteria[:page] || 1)
      |> to_string()
      |> String.to_integer()

    limit =
      (criteria[:limit] || 1)
      |> to_string()
      |> String.to_integer()

    query =
      criteria
      |> Map.put(:offset, (page - 1) * limit)
      |> Map.delete(:page)
      |> Map.to_list()
      |> Enum.reduce(query, fn {key, value}, query -> list_users(query, key, value) end)

    query_count =
      query
      |> exclude(:limit)
      |> exclude(:offset)

    result = Repo.all(query)

    %{
      data: Repo.all(query),
      total: Repo.aggregate(query_count, :count),
      total_current_get: length(result),
      page: page,
      limit: limit,
      offset: (page - 1) * limit
    }
  end

  ###
  # defp list_users(query, :limit, 0), do: query
  defp list_users(query, :limit, value), do: query |> limit(^value)
  defp list_users(query, :offset, 0), do: query
  defp list_users(query, :offset, value), do: query |> offset(^value)



  defp list_users(query, :preload, keys), do: query |> preload(^keys)

  defp list_users(query, :status, value),
    do: query |> where(status: ^value)

  defp list_users(query, :userid, userid),
    do: query |> where([u], like(u.userid, ^"%#{userid}%"))

  defp list_users(query, :name, name),
    do: query |> where([u], like(fragment("LOWER(?)", u.name), ^"%#{String.downcase(String.trim(name))}%"))

  defp list_users(query, :department_id, name),
    do: query |> where([u], like(fragment("LOWER(?)", u.department_id), ^"%#{String.downcase(String.trim(name))}%"))

  defp list_users(query, :team_id, name),
    do: query |> where([u], like(fragment("LOWER(?)", u.team_id), ^"%#{String.downcase(String.trim(name))}%"))

  defp list_users(query, :group_id, id) when is_bitstring(id),
    do: list_users(query, :group_id, String.to_integer(id))

  defp list_users(query, :group_id, id),
    do:
      query
      |> join(:inner, [u, m], m in UserGroupMap, on: m.user_id == u.id)
      |> where([u, m], m.group_id == ^id)

  defp list_users(query, :sort, %{sort_by: sort_by, sort_order: sort_order}),
    do: query |> order_by([{^sort_order, ^sort_by}])

  defp list_users(query, _key, _value), do: query

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

end
