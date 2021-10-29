defmodule NflRushing.Repo.Migrations.CreateTablePlayerStats do
  use Ecto.Migration

  def up do
    create table("player_stats", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :team, :string
      add :position, :string
      add :total_rushing_attempts, :integer
      add :rushing_attempts_per_game, :float
      add :total_rushing_yards, :float
      add :rushing_yards_per_attempt, :float
      add :rushing_yards_per_game, :float
      add :total_rushing_touchdowns, :integer
      add :longest_rush, :float
      add :was_longest_rush_a_touchdown, :boolean
      add :rushing_first_downs, :integer
      add :rushing_first_down_percentage, :float
      add :rushes_for_more_than_20_yards, :integer
      add :rushes_for_more_than_40_yards, :integer
      add :rushing_fumbles, :integer

      timestamps()
    end
  end

  def down do
    drop table("player_stats")
  end
end
