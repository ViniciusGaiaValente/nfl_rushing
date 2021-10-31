defmodule NflRushing.Stats.Commands.TranslateAndSanitizeInputTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats.Commands.TranslateAndSanitizeInput

  @raw_data %{
    "Player" => "Joe Banyard",
    "Team" => "JAX",
    "Pos" => "RB",
    "Att" => 2,
    "Att/G" => 2,
    "Yds" => 7,
    "Avg" => 3.5,
    "Yds/G" => 7,
    "TD" => 0,
    "Lng" => "7T",
    "1st" => 0,
    "1st%" => 0,
    "20+" => 0,
    "40+" => 0,
    "FUM" => 0
  }

  test "TranslateAndSanitizeInput.execute translate data correctly" do
    assert %{
             name: "Joe Banyard",
             team: "JAX",
             position: "RB",
             total_rushing_attempts: 2,
             rushing_attempts_per_game: 2,
             total_rushing_yards: 7,
             rushing_yards_per_attempt: 3.5,
             rushing_yards_per_game: 7,
             total_rushing_touchdowns: 0,
             longest_rush: 7.0,
             was_longest_rush_a_touchdown: true,
             rushing_first_downs: 0,
             rushing_first_down_percentage: 0,
             rushes_for_more_than_20_yards: 0,
             rushes_for_more_than_40_yards: 0,
             rushing_fumbles: 0
           } == TranslateAndSanitizeInput.execute(@raw_data)
  end

  test "TranslateAndSanitizeInput.execute does not break with invalid data" do
    TranslateAndSanitizeInput.execute(%{"foo" => "bar"})
  end
end
