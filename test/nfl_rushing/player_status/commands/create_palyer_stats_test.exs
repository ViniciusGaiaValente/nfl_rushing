defmodule NflRushing.Stats.Commands.CreatePlayerStatsTest do
  @moduledoc """
  Test module for NflRushing.Stats.Commands.CreatePlayerStats
  """

  use NflRushing.DataCase, async: true

  alias NflRushing.Repo
  alias NflRushing.Stats.Models.PlayerStats
  alias NflRushing.Stats.Commands.CreatePlayerStats

  @valid_data %{
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
    was_longest_rush_a_touchdown: false,
    rushing_first_downs: 0,
    rushing_first_down_percentage: 0,
    rushes_for_more_than_20_yards: 0,
    rushes_for_more_than_40_yards: 0,
    rushing_fumbles: 0
  }

  test "CreatePlayerStats.execute/1 creates insert the data correctly" do
    assert {:ok, %PlayerStats{id: id}} = CreatePlayerStats.execute(@valid_data)

    assert %PlayerStats{
             name: "Joe doe",
             team: "DAT",
             position: "DAP",
             total_rushing_attempts: 2.0,
             rushing_attempts_per_game: 2.0,
             total_rushing_yards: 7.0,
             rushing_yards_per_attempt: 3.5,
             rushing_yards_per_game: 7.0,
             total_rushing_touchdowns: 0,
             longest_rush: 10.0,
             was_longest_rush_a_touchdown: false,
             rushing_first_downs: 0,
             rushing_first_down_percentage: 0,
             rushes_for_more_than_20_yards: 0,
             rushes_for_more_than_40_yards: 0,
             rushing_fumbles: 0
             inserted_at: _,
             updated_at: _,
             was_longest_rush_a_touchdown: false
           } = Repo.get_by(PlayerStats, id: id) |> IO.inspect()
  end
end
