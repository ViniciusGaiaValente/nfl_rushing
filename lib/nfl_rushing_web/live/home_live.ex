defmodule NflRushingWeb.HomeLive do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats.Commands.IndexPlayerStats

  def mount(_params, _session, socket) do
    results = IndexPlayerStats.execute()

    {:ok, assign(socket, %{name_filter: nil, sorting_options: [], results: results})}
  end
end
