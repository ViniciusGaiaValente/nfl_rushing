import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :nfl_rushing, NflRushing.Repo,
  hostname: System.get_env("DATABASE_HOST"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: "#{System.get_env("DATABASE_DB")}_test",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nfl_rushing, NflRushingWeb.Endpoint,
  http: [port: 4002],
  secret_key_base: "Vv8NnN1tBORw2I80PVAIM9XNK5z5xKcHMiKW6r4+J+8n0BChoa9NZ8bO2F/e8iDw",
  server: false

# In test we don't send emails.
config :nfl_rushing, NflRushing.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
