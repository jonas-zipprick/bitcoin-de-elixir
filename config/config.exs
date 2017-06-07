use Mix.Config

import_config "config.secret.exs"

config :bitcoin_de, server: 
  %{
    host: "https://api.bitcoin.de",
    port: 80 
  }

