defmodule BitcoinDe do
  use GenServer 
  alias BitcoinDe.ApiRequestBuilder, as: ApiRequestBuilder
  alias BitcoinDe.ApiRequest, as: ApiRequest

  @moduledoc """
  A Client for bitcoin.de
  """

  @doc """
  Start the connection to bitcoin.de
  ## Examples

      iex> BitcoinDe.start_link(self(), %BitcoinDe.Credentials{key: "xxxxx", secret: "xxxxx"})
      :ok

  """
  def start_link(parent, credentials = %BitcoinDe.Credentials{}) do
    GenServer.start_link(__MODULE__, {parent, credentials}) 
  end

  def init(state) do
    {:ok, _} = HTTPoison.start
    test_api()
    {:ok, state}
  end

  defp test_api() do
    evaluate(ApiRequestBuilder.create_trade(:buy, 0.1, 1000))
  end

  @spec evaluate(%ApiRequest{}) :: atom 
  defp evaluate(api_request)  do
    IO.inspect api_request 
  end

end
