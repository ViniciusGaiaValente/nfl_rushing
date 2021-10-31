defmodule NflRushing.Stats.Commands.CastPlayerStatsFiltersTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats.Commands.CastPlayerStatsFilters

  test "CastPlayerStatsFiltersTest.execute/1 cast data correctly" do
    assert CastPlayerStatsFilters.execute(%{
             "name" => "Jhon Doe",
             "order_by_0" => "Yds",
             "order_by_0_flow" => "asc",
             "order_by_1" => "Lng",
             "order_by_1_flow" => "desc",
             "order_by_2" => "TD",
             "order_by_2_flow" => "asc"
           }) == %{
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
  end
end
