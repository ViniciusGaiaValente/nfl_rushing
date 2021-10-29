defmodule NflRushing.Stats.Commands.TranslateAndSanitizeInput do
  @moduledoc """
  Command to translate raw input data to the expected format at NflRushing.Stats.Models.PlayerStats, and normalize possible inconsistent fields.
  """

  @doc """
  Receive a map with raw data in a possible inconsistent format. Translate it and normalize the fields: `:longest_rush` and `:total_rushing_yards`.

  After the translation, if the field: `:longest_rush` is a string and ends with "T", remove the "T" and cast it to float.
  If so, also mark the field: `:was_longest_rush_a_touchdown` to true.

  If `:total_rushing_yards` is a string, cast it to float, considering dots as a decimal separator and comas as a thousand separator.

  ## Examples
      iex> NflRushing.Stats.Commands.TranslateAndSanitizeInput.execute(%{
        "Player" => "Joe doe",
        "Team" => "DAT",
        "Pos" => "DAP",
        "Att" => 2,
        "Att/G" => 2,
        "Yds" => 7,
        "Avg" => 3.5,
        "Yds/G" => 7,
        "TD" => 0,
        "Lng" => "10T",
        "1st" => 0,
        "1st%" => 0,
        "20+" => 0,
        "40+" => 0,
        "FUM" => 0
      })
      %{
       "name" => "Joe doe",
       "team" => "DAT",
       "position" => "DAP",
       "total_rushing_attempts" => 2,
       "rushing_attempts_per_game" => 2,
       "total_rushing_yards" => 7,
       "rushing_yards_per_attempt" => 3.5,
       "rushing_yards_per_game" => 7,
       "total_rushing_touchdowns" => 0,
       "longest_rush" => "10T",
       "rushing_first_downs" => 0,
       "rushing_first_down_percentage" => 0,
       "rushes_for_more_than_20_yards" => 0,
       "rushes_for_more_than_40_yards" => 0,
       "rushing_fumbles" => 0
      }
  """
  @spec execute(map()) :: map()
  def execute(params) do
    params
    |> translate_data()
    |> sanitize_data()
  end

  defp translate_data(data) do
    %{
      name: Map.get(data, "Player"),
      team: Map.get(data, "Team"),
      position: Map.get(data, "Pos"),
      longest_rush: Map.get(data, "Lng"),
      total_rushing_touchdowns: Map.get(data, "TD"),
      total_rushing_yards: Map.get(data, "Yds"),
      total_rushing_attempts: Map.get(data, "Att"),
      rushing_attempts_per_game: Map.get(data, "Att/G"),
      rushing_yards_per_attempt: Map.get(data, "Avg"),
      rushing_yards_per_game: Map.get(data, "Yds/G"),
      rushing_first_downs: Map.get(data, "1st"),
      rushing_first_down_percentage: Map.get(data, "1st%"),
      rushes_for_more_than_20_yards: Map.get(data, "20+"),
      rushes_for_more_than_40_yards: Map.get(data, "40+"),
      rushing_fumbles: Map.get(data, "FUM")
    }
  end

  defp sanitize_data(data) do
    data
    |> translate_total_rushing_yards()
    |> translate_longest_rush()
  end

  defp translate_total_rushing_yards(%{total_rushing_yards: total_rushing_yards} = params)
       when is_bitstring(total_rushing_yards) do
    Map.replace(
      params,
      :total_rushing_yards,
      total_rushing_yards
      |> String.replace(",", "")
      |> Float.parse()
      |> elem(0)
    )
  end

  defp translate_total_rushing_yards(params), do: params

  defp translate_longest_rush(%{longest_rush: longest_rush} = params)
       when is_bitstring(longest_rush) do
    case Float.parse(longest_rush) do
      {value, "T"} ->
        params
        |> Map.replace(:longest_rush, value)
        |> Map.put_new(:was_longest_rush_a_touchdown, true)

      {value, _} ->
        params
        |> Map.replace(:longest_rush, value)
    end
  end

  defp translate_longest_rush(params), do: params
end
