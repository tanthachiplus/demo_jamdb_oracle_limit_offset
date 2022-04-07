defmodule DemoJamdbOracleLimitOffset.Repo.Migrations.CreateTableAccount do
  use Ecto.Migration

  def change do
    create table(:users_demo) do
      add :name, :string

      timestamps(type: :naive_datetime_usec)
    end

  execute "CREATE SEQUENCE users_demo_seq
    START WITH     1
    INCREMENT BY   1"

    execute "ALTER TABLE users_demo MODIFY id NUMBER DEFAULT users_demo_seq.nextval"

    alter table("users_demo") do
      modify :id, :integer
    end

  end
end
