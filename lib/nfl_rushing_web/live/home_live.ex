defmodule NflRushingWeb.HomeLive do
  use NflRushingWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, game_previews: [])}
  end
end
