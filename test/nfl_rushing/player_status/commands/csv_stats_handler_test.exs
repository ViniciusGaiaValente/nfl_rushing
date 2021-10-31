defmodule NflRushing.Stats.Commands.CsvStatsHandlerTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats.Commands.CsvStatsHandler
  alias NflRushing.Stats.Models.PlayerStats

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

  test "CsvStatsHandler.stream_results/3 stream headers correctly" do
    CsvStatsHandler.stream_results(
      fn stream ->
        list =
          for csv_row <- stream do
            csv_row
            |> Enum.reject(fn x -> x == 44 end)
          end

        assert Enum.any?(list, fn x ->
                 x == [
                   "Player",
                   "Team",
                   "Pos",
                   "Att",
                   "Att/G",
                   "Yds",
                   "Avg",
                   "Yds/G",
                   "TD",
                   "Lng",
                   "Lng/TD",
                   "1st",
                   "1st%",
                   "20+",
                   "40+",
                   "FUM",
                   "\r\n"
                 ]
               end)
      end,
      nil,
      []
    )
  end

  test "CsvStatsHandler.stream_results/3 stream content correctly" do
    CsvStatsHandler.stream_results(
      fn stream ->
        list =
          for csv_row <- stream do
            csv_row
          end

        assert list
               |> Enum.at(1)
               |> Enum.at(0)
               |> Enum.reject(fn x -> x == 44 end) == [
                 "John A Doe 2",
                 "FOO",
                 "BAR",
                 "0",
                 "0.0",
                 "1.0",
                 "0.0",
                 "0.0",
                 "4",
                 "1.0",
                 "false",
                 "0",
                 "0.0",
                 "0",
                 "0",
                 "0",
                 "\r\n"
               ]
      end,
      "A",
      desc: :total_rushing_touchdowns
    )
  end
end
