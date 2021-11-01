defmodule NflRushingWeb.HomeLive do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats.Commands.CastPlayerStatsFilters
  alias NflRushing.Stats.Commands.IndexPlayerStats

  def mount(_params, _session, socket) do
    socket = fetch_data(socket)

    {:ok, socket}
  end

  def handle_event("search", %{"params" => params}, socket) do
    socket = fetch_data(socket, params)

    {:noreply, socket}
  end

  defp fetch_data(socket),
    do:
      assign(socket, %{
        results: IndexPlayerStats.execute(),
        name: nil,
        order_by_0: "-",
        order_by_0_flow: "desc",
        order_by_1: "-",
        order_by_1_flow: "desc",
        order_by_2: "-",
        order_by_2_flow: "desc",
        sort_by: []
      })

  defp fetch_data(socket, params) do
    params = CastPlayerStatsFilters.execute(params)

    %{name: name, sort_by: sort_by} = params

    assign(
      socket,
      Map.put_new(params, :results, IndexPlayerStats.execute(name, sort_by))
    )
  end
end
