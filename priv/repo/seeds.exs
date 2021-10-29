# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

with [] <- NflRushing.Repo.all(NflRushing.Stats.Models.PlayerStats),
     {:ok, body} <- File.read("./rushing.json"),
     {:ok, json} <- Jason.decode(body) do
  Enum.each(json, fn data ->
    data
    |> NflRushing.Stats.Commands.TranslateAndSanitizeInput.execute()
    |> NflRushing.Stats.Commands.CreatePlayerStats.execute()
  end)
else
  list when is_list(list) ->
    IO.inspect("DATABASE ALREADY SEEDED")
end
