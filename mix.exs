defmodule BitcoinDe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bitcoin_de,
      version: "0.1.1",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "BitcoinDe",
      source_url: "https://github.com/balugege/bitcoin-de-elixir"
    ]
  end

  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.2"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description do
    "Elixir API wrapper for www.bitcoin.de an online bitcoin marketplace."
  end

  defp package do
    [
      name: :bitcoin_de,
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Jonas Zipprick"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/balugege/bitcoin-de-elixir"}
    ]
  end
end
