defmodule NflRushing.Stats.Commands.IndexPlayerStats do
  @moduledoc """
  Command to fetch NflRushing.Stats.Models.PlayerStats records from the database.
  """

  import Ecto.Query
  alias NflRushing.Repo
  alias NflRushing.Stats.Models.PlayerStats

  @doc """
  Fetches `NflRushing.Stats.Models.PlayerStats` records, the result can be optionally filtered and ordered.

  The first parameter is a string used to filter to the field `:name`, if no filter is intended, set it nil.

  The second parameter is a list of tuples, representing the sorting options.
  Each tuple must contain an atom indicating its direction: `:asc` for ascending and:`:desc` for descending followed by the field to be sorted.
  The three possible fields are: `:total_rushing_yards`, `:longest_rush`, `:total_rushing_touchdowns`.
  The result will be sorted prioritizing items according to their order in the list (the first one has the highest priority and the last one the lowest).


  ## Sorting Option Examples
      [{:asc ,:total_rushing_yards}, {:desc ,:longest_rush}]
      [{:desc ,:total_rushing_yards}, {:desc ,:total_rushing_touchdowns}]
      [{:asc ,:total_rushing_yards}, {:desc ,:longest_rush}, {:asc ,:total_rushing_touchdowns}]
  """
  @spec execute(
          String.t() | nil,
          [
            {
              :asc | :desc,
              :total_rushing_yards | :longest_rush | :total_rushing_touchdowns
            }
          ]
        ) :: [map]
  def execute(name, sort_by \\ []) do
    name
    |> build_query(sort_by)
    |> Repo.all()
  end

  @spec execute :: [map]
  def execute(), do: execute(nil)

  @doc """
  Builds a query to fetch `NflRushing.Stats.Models.PlayerStats`, the result can be optionally filtered and ordered.

  The first parameter is a string used to filter to the field `:name`, if no filter is intended, set it nil.

  The second parameter is a list of tuples, representing the sorting options.
  Each tuple must contain an atom indicating its direction: `:asc` for ascending and:`:desc` for descending followed by the field to be sorted.
  The three possible fields are: `:total_rushing_yards`, `:longest_rush`, `:total_rushing_touchdowns`.
  The result will be sorted prioritizing items according to their order in the list (the first one has the highest priority and the last one the lowest).


  ## Sorting Option Examples
      [{:asc ,:total_rushing_yards}, {:desc ,:longest_rush}]
      [{:desc ,:total_rushing_yards}, {:desc ,:total_rushing_touchdowns}]
      [{:asc ,:total_rushing_yards}, {:desc ,:longest_rush}, {:asc ,:total_rushing_touchdowns}]
  """
  @spec build_query(
          String.t() | nil,
          [
            {
              :asc | :desc,
              :total_rushing_yards | :longest_rush | :total_rushing_touchdowns
            }
          ]
        ) :: Ecto.Query.t()
  def build_query(name, sort_by \\ []) do
    from(p in PlayerStats)
    |> add_name_filter(name)
    |> add_sorting_options(sort_by)
  end

  defp add_name_filter(query, nil), do: query

  defp add_name_filter(query, name),
    do: where(query, [p], like(p.name, ^"%#{name}%"))

  defp add_sorting_options(query, []), do: query

  defp add_sorting_options(query, sort_by) when is_list(sort_by) do
    from(p in query, order_by: ^sort_by)
  end
end
