defmodule NflRushing.Stats.Commands.CreatePlayerStats do
  @moduledoc """
  Command to insart a NflRushing.Stats.Models.PlayerStats in the database
  """

  alias NflRushing.Repo
  alias NflRushing.Stats.Models.PlayerStats

  @doc """
  Receive a map pass it through the `NflRushing.Stats.Models.PlayerStats` changeset and tries to insert it on the database.

  Return a tuple with either :ok and the struct inserted or :error and the invalid changeset

  ## Examples
      iex> NflRushing.Stats.Commands.CreatePlayer.execute(%{
        name: "Joe doe",
        team: "DAT",
        position: "DAP",
        total_rushing_attempts: 2,
        rushing_attempts_per_game: 2,
        total_rushing_yards: 7,
        rushing_yards_per_attempt: 3.5,
        rushing_yards_per_game: 7,
        total_rushing_touchdowns: 0,
        longest_rush: 10,
        was_longest_rush_a_touchdown: true,
        rushing_first_downs: 0,
        rushing_first_down_percentage: 0,
        rushes_for_more_than_20_yards: 0,
        rushes_for_more_than_40_yards: 0,
        rushing_fumbles: 0
      })
      {:ok, %NflRushing.Stats.Models.PlayerStats{
        __meta__: #Ecto.Schema.Metadata<:loaded, "player_stats">,
        id: "75218224-c62b-416d-ad1a-78eef64a3507",
        inserted_at: ~N[2021-10-28 10:27:36],
        longest_rush: 10.0,
        name: "Joe doe",
        position: "DAP",
        rushes_for_more_than_20_yards: 0,
        rushes_for_more_than_40_yards: 0,
        rushing_attempts_per_game: 2.0,
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_fumbles: 0,
        rushing_yards_per_attempt: 3.5,
        rushing_yards_per_game: 7.0,
        team: "DAT",
        total_rushing_attempts: 2,
        total_rushing_touchdowns: 0,
        total_rushing_yards: 7.0,
        updated_at: ~N[2021-10-28 10:27:36],
        was_longest_rush_a_touchdown: true
      }}
  """
  @spec execute(map()) :: {:ok, PlayerStats} | {:error, Ecto.Changeset}
  def execute(params) do
    params
    |> PlayerStats.changeset()
    |> Repo.insert()
  end
end
