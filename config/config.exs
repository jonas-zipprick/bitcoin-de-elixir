use Mix.Config

import_config "config.secret.exs"

config :logger,
  backends: [:console],
  compile_time_purge_level: :info

config :bitcoin_de, server: 
  %{
    host: "https://api.bitcoin.de",
    port: 80 
  }

