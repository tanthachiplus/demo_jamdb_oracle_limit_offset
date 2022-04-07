# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DemoJamdbOracleLimitOffset.Repo.insert!(%DemoJamdbOracleLimitOffset.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DemoJamdbOracleLimitOffset.Repo


Enum.reduce(1..1000, Ecto.Multi.new(), fn x, multi ->
  multi
  |> Ecto.Multi.insert("#{x}", %Users{name: "Tan #{x}"},[])
end)
|> Repo.transaction()
