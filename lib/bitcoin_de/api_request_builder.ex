defmodule BitcoinDe.ApiRequestBuilder do
  alias BitcoinDe.ApiRequest, as: ApiRequest
  alias BitcoinDe.Credentials, as: Credentials 

  @typedoc """
  all the information neccessary to construct an api_request
  """
  @type params :: [{atom, any}, ...]

  @type signature :: String.t

  @spec sort(params) :: params
  defp sort(params) do
    params |> Enum.sort_by(&(elem(&1, 0)))
  end

  defimpl Inspect, for: Atom do
    def inspect(dict) do
      Atom.to_string(dict)
    end

    def inspect(dict, _) do
      Atom.to_string(dict)
    end
  end
    
  @spec url_encode(params) :: BitcoinDe.url_query 
  defp url_encode(params) do
    url_encode(params, "")
  end

  defp url_encode([], url_query) do
    url_query
  end

  defp url_encode([head | tail], url_query) do
    url_query = url_query <> unless (url_query == ""), do: "&", else: ""
    url_query = head
                |> elem(0)
                |> Kernel.inspect
                |> (&(url_query <> &1 <> "=")).()
    url_query = head
                |> elem(1)
                |> (&(if is_binary(&1), do: &1, else: Kernel.inspect(&1))).()
                |> (&(url_query <> &1)).()
    url_encode(tail, url_query)
  end

  @spec add_signature(%ApiRequest{}, params, %Credentials{}) :: %ApiRequest{} 
  defp add_signature(api_request = %ApiRequest{method: :post}, params, credentials = %Credentials{}) do

    url_query_list = params
                     |> Enum.map(fn {k, v} -> {k, inspect(v)} end)

    url_query = params
                |> Enum.filter(fn({_, v}) -> v != nil end)
                |> sort
                |> url_encode

    md5_hash = :crypto.hash(:md5, url_query)
               |> Base.encode16()
               |> String.downcase
                
    uri = Enum.join([
      "https://api.bitcoin.de",
      api_request.path
    ])

    hmac_data = Enum.join([
      "POST",
      uri,
      (credentials |> Map.fetch!(:key)),
      (api_request.nonce |> Kernel.inspect),
      md5_hash], "#")

    IO.inspect hmac_data

    signature = credentials
                |> Map.fetch!(:secret)
                |> (&(:crypto.hmac(:sha256, &1, hmac_data))).()
                |> Base.encode16
                |> String.downcase
    %ApiRequest{api_request | uri: uri, signature: signature, url_query: url_query_list}
  end
  
  defp add_signature(api_request = %ApiRequest{method: :get}, params, credentials = %Credentials{}) do
    url_query = params 
                |> Enum.filter(fn({_, v}) -> v != nil end) 
                |> url_encode

    uri = Enum.join([
      "https://api.bitcoin.de",
      api_request.path,
      (if url_query != "", do: "?", else: ""),
      url_query
    ])

    md5_hash = "d41d8cd98f00b204e9800998ecf8427e"

    hmac_data = Enum.join([
      "GET",
      uri,
      (credentials |> Map.fetch!(:key)),
      (api_request.nonce |> Kernel.inspect),
      md5_hash], "#")

    signature = credentials 
                |> Map.fetch!(:secret)
                |> (&(:crypto.hmac(:sha256, &1, hmac_data))).()
                |> Base.encode16
                |> String.downcase

    %ApiRequest{api_request | uri: uri, signature: signature}
  end


  defp nonce() do
    :os.system_time(:millisecond)
  end

  @spec show_orderbook(%Credentials{}, atom, number, number) :: %ApiRequest{}
  def show_orderbook(credentials = %Credentials{}, type, amount \\ nil, price \\ nil) do
    params = [type: type, amount: amount, price: price]  
    %ApiRequest{method: :get, path: "/v1/orders", nonce: nonce()} 
    |> add_signature(params, credentials)
  end

  @spec show_public_trade_history(%Credentials{}, number) :: %ApiRequest{}
  def show_public_trade_history(credentials = %Credentials{}, since_tid \\ nil) do
    params = [since_tid: since_tid]
    %ApiRequest{method: :get, path: "/v1/trades/history", nonce: nonce()} 
    |> add_signature(params, credentials)
  end

  @spec show_account_info(%Credentials{}) :: %ApiRequest{}
  def show_account_info(credentials = %Credentials{}) do
    params = []
    %ApiRequest{method: :get, path: "/v1/account", nonce: nonce()} 
    |> add_signature(params, credentials)
  end

  @spec execute_trade(%Credentials{}, integer, atom, float) :: %ApiRequest{}
  def execute_trade(credentials = %Credentials{}, order_id, type, amount) do
    params = [type: type, amount: amount]
    %ApiRequest{method: :post, path: "/v1/trades/" <> order_id, nonce: nonce()}
    |> add_signature(params, credentials)
  end

  @spec create_order(%Credentials{}, atom, float, float) :: %ApiRequest{}
  def create_order(credentials = %Credentials{}, type, max_amount, price) do
    params = [type: type, max_amount: max_amount, price: price]
    %ApiRequest{method: :post, path: "/v1/orders" ,nonce: nonce()}
    |> add_signature(params, credentials)
  end
end
