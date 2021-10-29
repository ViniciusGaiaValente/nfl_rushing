defmodule NflRushing.Stats.Models.PlayerStats do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :name,
    :team,
    :position,
    :total_rushing_attempts,
    :rushing_attempts_per_game,
    :total_rushing_yards,
    :rushing_yards_per_attempt,
    :rushing_yards_per_game,
    :total_rushing_touchdowns,
    :longest_rush,
    :was_longest_rush_a_touchdown,
    :rushing_first_downs,
    :rushing_first_down_percentage,
    :rushes_for_more_than_20_yards,
    :rushes_for_more_than_40_yards,
    :rushing_fumbles
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "player_stats" do
    field :name, :string
    field :team, :string
    field :position, :string
    field :total_rushing_attempts, :integer
    field :rushing_attempts_per_game, :float
    field :total_rushing_yards, :float
    field :rushing_yards_per_attempt, :float
    field :rushing_yards_per_game, :float
    field :total_rushing_touchdowns, :integer
    field :longest_rush, :float
    field :was_longest_rush_a_touchdown, :boolean, default: false
    field :rushing_first_downs, :integer
    field :rushing_first_down_percentage, :float
    field :rushes_for_more_than_20_yards, :integer
    field :rushes_for_more_than_40_yards, :integer
    field :rushing_fumbles, :integer

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
