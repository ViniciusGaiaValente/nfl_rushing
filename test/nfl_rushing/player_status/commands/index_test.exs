defmodule NflRushing.Stats.Commands.IndexPlayerStatsTest do
  @moduledoc """
  Test module for NflRushing.Stats.Commands.IndexPlayerStats
  """
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats.Models.PlayerStats
  alias NflRushing.Stats.Commands.IndexPlayerStats

  @data [
    %{
      name: "John A Doe 1",
      team: "FOO",
      position: "BAR",
      longest_rush: 1,
      total_rushing_touchdowns: 3,
      total_rushing_yards: 2,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    },
    %{
      name: "John A Doe 2",
      team: "FOO",
      position: "BAR",
      longest_rush: 1,
      total_rushing_touchdowns: 4,
      total_rushing_yards: 1,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    },
    %{
      name: "John A Doe 3",
      team: "FOO",
      position: "BAR",
      longest_rush: 1,
      total_rushing_touchdowns: 4,
      total_rushing_yards: 2,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    },
    %{
      name: "John B Doe 4",
      team: "FOO",
      position: "BAR",
      longest_rush: 2,
      total_rushing_touchdowns: 1,
      total_rushing_yards: 3,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    },
    %{
      name: "John B Doe 5",
      team: "FOO",
      position: "BAR",
      longest_rush: 2,
      total_rushing_touchdowns: 1,
      total_rushing_yards: 4,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    },
    %{
      name: "John B Doe 6",
      team: "FOO",
      position: "BAR",
      longest_rush: 2,
      total_rushing_touchdowns: 2,
      total_rushing_yards: 3,
      total_rushing_attempts: 0,
      rushing_attempts_per_game: 0,
      rushing_yards_per_attempt: 0,
      rushing_yards_per_game: 0,
      was_longest_rush_a_touchdown: false,
      rushing_first_downs: 0,
      rushing_first_down_percentage: 0,
      rushes_for_more_than_20_yards: 0,
      rushes_for_more_than_40_yards: 0,
      rushing_fumbles: 0
    }
  ]

  setup do
    Enum.each(@data, fn data ->
      data
      |> PlayerStats.changeset()
      |> Repo.insert()
    end)

    on_exit(fn -> Repo.delete_all(PlayerStats) end)
  end

  test "IndexPlayerStats.execute returns all the records" do
    assert 6 == length(IndexPlayerStats.execute())
  end

  test "IndexPlayerStats.execute sort data correctly" do
    assert [%{name: "John A Doe 2"} | _] =
             IndexPlayerStats.execute(nil, [
               {:asc, :longest_rush},
               {:desc, :total_rushing_touchdowns},
               {:asc, :total_rushing_yards}
             ])

    assert [%{name: "John B Doe 5"} | _] =
             IndexPlayerStats.execute(nil, [
               {:desc, :longest_rush},
               {:asc, :total_rushing_touchdowns},
               {:desc, :total_rushing_yards}
             ])
  end

  test "IndexPlayerStats.execute filter data correctly" do
    assert [%{name: "John A Doe 1"}, %{name: "John A Doe 2"}, %{name: "John A Doe 3"}] =
             IndexPlayerStats.execute("A")

    assert [%{name: "John B Doe 4"}, %{name: "John B Doe 5"}, %{name: "John B Doe 6"}] =
             IndexPlayerStats.execute("B")
  end
end
