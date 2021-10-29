defmodule NflRushing.Repo.Migrations.CreateIndexes do
  use Ecto.Migration

  def up do
    create index("player_stats", [:name], comment: "player_stats_name")
    create index("player_stats", [:total_rushing_yards], comment: "player_stats_total_rushing_yards")
    create index("player_stats", [:longest_rush], comment: "player_stats_longest_rush")
    create index("player_stats", [:total_rushing_touchdowns], comment: "player_stats_total_rushing_touchdowns")
  end

  def down do
    drop index("player_stats", [:name])
    drop index("player_stats", [:total_rushing_yards])
    drop index("player_stats", [:longest_rush])
    drop index("player_stats", [:total_rushing_touchdowns])
  end
end
