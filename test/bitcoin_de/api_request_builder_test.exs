defmodule BitcoinDe.ApiCallBuilderTest do
  use ExUnit.Case
  alias BitcoinDe.ApiRequestBuilder, as: Builder

  doctest Builder

  test "create trade" do
    {:ok, url_query} = Builder.create_trade(:buy, 5.3, 255.50)
    IO.inspect url_query
    assert is_bitstring(url_query)
    # string should be encrypted so the original values should not be readable
    refute String.contains?(url_query, "buy")
  end
end
