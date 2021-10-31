defmodule NflRushingWeb.CsvController do
  use NflRushingWeb, :controller

  alias NflRushing.Stats.Commands.CastPlayerStatsFilters
  alias NflRushing.Stats.Commands.CsvStatsHandler

  def show(conn, params) do
    %{name: name, sort_by: sort_by} = CastPlayerStatsFilters.execute(params)

    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="stats.csv"])
      |> send_chunked(:ok)

    CsvStatsHandler.stream_results(
      fn stream ->
        for csv_row <- stream do
          chunk(conn, csv_row)
        end
      end,
      name,
      sort_by
    )

    conn
  end
end
