defmodule NflRushing.Stats.Commands.CsvStatsHandler do
  @moduledoc """
  Command to wrap NimbleCSV specific operations
  """

  alias NflRushing.Repo
  alias NflRushing.Stats.Commands.IndexPlayerStats
  NflRushing.Stats.Models.PlayerStats

  @doc """
  Builds a query to fetch `NflRushing.Stats.Models.PlayerStats` based on `name` filter and the `sort_by` sort options.
  Serve the results from the query as CSV rows executing the received `callback` on a Stream.
  """
  @spec stream_results(
          function(),
          nil | String.t(),
          list({:asc | :desc, :longest_rush | :total_rushing_touchdowns | :total_rushing_yards})
        ) :: any
  def stream_results(callback, name, sort_by) do
    query = IndexPlayerStats.build_query(name, sort_by)

    Repo.transaction(fn ->
      stream =
        query
        |> Repo.stream()
        |> Stream.map(fn record ->
          translate_result_into_csv_row(record)
        end)

      build_csv_header()
      |> Stream.concat(stream)
      |> callback.()
    end)
  end

  defp build_csv_header() do
    [
      [
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
        "FUM"
      ]
    ]
    |> NimbleCSV.RFC4180.dump_to_iodata()
  end

  defp translate_result_into_csv_row(%NflRushing.Stats.Models.PlayerStats{} = result) do
    [
      [
        result.name,
        result.team,
        result.position,
        result.total_rushing_attempts,
        result.rushing_attempts_per_game,
        result.total_rushing_yards,
        result.rushing_yards_per_attempt,
        result.rushing_yards_per_game,
        result.total_rushing_touchdowns,
        result.longest_rush,
        result.was_longest_rush_a_touchdown,
        result.rushing_first_downs,
        result.rushing_first_down_percentage,
        result.rushes_for_more_than_20_yards,
        result.rushes_for_more_than_40_yards,
        result.rushing_fumbles
      ]
    ]
    |> NimbleCSV.RFC4180.dump_to_iodata()
  end
end
