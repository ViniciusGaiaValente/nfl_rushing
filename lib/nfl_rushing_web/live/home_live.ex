defmodule NflRushingWeb.HomeLive do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats.Commands.IndexPlayerStats

  def mount(_params, _session, socket) do
    socket = fetch_data(socket)

    {:ok, socket}
  end

  def handle_event("save", %{"params" => params}, socket) do
    socket = fetch_data(socket, params)

    {:noreply, socket}
  end

  defp fetch_data(socket), do: assign(socket, %{results: IndexPlayerStats.execute()})

  defp fetch_data(socket, params) do
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

    order_by =
      Enum.filter(
        [
          {order_by_0_flow, order_by_0},
          {order_by_1_flow, order_by_1},
          {order_by_2_flow, order_by_2}
        ],
        fn {_flow, value} -> value != nil end
      )

    assign(socket, %{results: IndexPlayerStats.execute(name, order_by)})
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
