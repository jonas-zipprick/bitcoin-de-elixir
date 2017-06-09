defmodule BitcoinDe.ApiCallBuilderTest do
  use ExUnit.Case
  alias BitcoinDe.ApiRequestBuilder, as: Builder
  doctest Builder

  setup_all do
    {:ok, credentials: struct(BitcoinDe.Credentials, Application.get_env(:bitcoin_de, :credentials))}
  end
  test "create trade", state do
    api_request = Builder.show_orderbook(state[:credentials], :buy, 5.3, 255.50)
    assert is_map(api_request)
    assert Map.has_key?(api_request, :signature)
  end
end
