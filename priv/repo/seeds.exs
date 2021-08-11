# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Milk.Repo.insert!(%Milk.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for color <- ~w(red green blue orange purple) do
  Milk.Repo.insert!(%Milk.Bottles.Bottle{name: color, color: color})
end
