defmodule Users do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users_demo" do
    field(:id, :integer, primary_key: true)
    field(:name, :string)

    timestamps(type: :naive_datetime_usec)
  end

  @optional_keys []
  @required_keys [:name]

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_keys ++ @optional_keys)
    |> add_id()
  end

  def add_id(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      case changeset do
        %{action: :insert} ->
          changeset
          |> put_change(
            :id,
            ### test
            # Ecto.Adapters.SQL.query!(changeset.repo, "SELECT nextval('users_id_seq')").rows
            # for production
            Ecto.Adapters.SQL.query!(changeset.repo, "SELECT users_seq.NEXTVAL FROM dual").rows
            |> List.first()
            |> List.first()
          )

        _ ->
          changeset
      end
    end)
  end
end
