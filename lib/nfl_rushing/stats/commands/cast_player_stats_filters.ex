defmodule NflRushing.Stats.Commands.CastPlayerStatsFilters do
  @moduledoc """
  Command to transform raw params into `NflRushing.Stats.Models.PlayerStats` filters and sort_by options
  """

  @doc """
  Recieve a raw map (string to string).
  Returns a map containing the name to be used as a filter, a keyword list to be used a sort option

  ## Examples
      >iex NflRushing.Stats.Commands.CreatePlayer.execute(%{
        "name" => "Jhon Doe",
        "order_by_0" => "Yds",
        "order_by_0_flow" => "asc",
        "order_by_1" => "Lng",
        "order_by_1_flow" => "desc",
        "order_by_2" => "TD",
        "order_by_2_flow" => "asc",
      })
      %{
        name: "Jhon Doe",
        order_by_0: "Yds",
        order_by_0_flow: "asc",
        order_by_1: "Lng",
        order_by_1_flow: "desc",
        order_by_2: "TD",
        order_by_2_flow: "asc",
        sort_by: [
          asc: :total_rushing_yards,
          desc: :longest_rush,
          asc: :total_rushing_touchdowns
        ]
      }
  """
  @spec execute(map) :: %{
          name: nil | String.t(),
          order_by_0: :longest_rush | :total_rushing_touchdowns | :total_rushing_yards | nil,
          order_by_0_flow: :asc | :desc | nil,
          order_by_1: :longest_rush | :total_rushing_touchdowns | :total_rushing_yards | nil,
          order_by_1_flow: :asc | :desc | nil,
          order_by_2: :longest_rush | :total_rushing_touchdowns | :total_rushing_yards | nil,
          order_by_2_flow: :asc | :desc | nil,
          sort_by: Keyword.t()
        }
  def execute(params) do
    name =
      params
      |> extract_value("name")

    order_by_0 =
      params
      |> extract_value("order_by_0")
      |> translate_field()

    order_by_0_flow =
      params
      |> extract_value("order_by_0_flow")
      |> translate_flow()

    order_by_1 =
      params
      |> extract_value("order_by_1")
      |> translate_field()

    order_by_1_flow =
      params
      |> extract_value("order_by_1_flow")
      |> translate_flow()

    order_by_2 =
      params
      |> extract_value("order_by_2")
      |> translate_field()

    order_by_2_flow =
      params
      |> extract_value("order_by_2_flow")
      |> translate_flow()

    %{
      name: name,
      order_by_0: Map.get(params, "order_by_0"),
      order_by_0_flow: Map.get(params, "order_by_0_flow"),
      order_by_1: Map.get(params, "order_by_1"),
      order_by_1_flow: Map.get(params, "order_by_1_flow"),
      order_by_2: Map.get(params, "order_by_2"),
      order_by_2_flow: Map.get(params, "order_by_2_flow"),
      sort_by:
        Enum.filter(
          [
            {order_by_0_flow, order_by_0},
            {order_by_1_flow, order_by_1},
            {order_by_2_flow, order_by_2}
          ],
          fn {_flow, value} -> value != nil end
        )
    }
  end

  defp extract_value(params, value) do
    params
    |> Map.get(value, "")
    |> String.trim()
    |> case do
      "" ->
        nil

      order_by_0 ->
        order_by_0
    end
  end

  defp translate_field("Yds"), do: :total_rushing_yards
  defp translate_field("Lng"), do: :longest_rush
  defp translate_field("TD"), do: :total_rushing_touchdowns
  defp translate_field(nil), do: nil

  defp translate_flow("asc"), do: :asc
  defp translate_flow("desc"), do: :desc
  defp translate_flow(nil), do: nil
end
