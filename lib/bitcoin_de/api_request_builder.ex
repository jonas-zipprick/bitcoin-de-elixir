defmodule BitcoinDe.ApiRequestBuilder do
  alias BitcoinDe.ApiRequest, as: ApiRequest

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

    def inspect(dict, opts) do
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
                |> Kernel.inspect
                |> (&(url_query <> &1)).()
    url_encode(tail, url_query)
  end

  @spec add_signature(%ApiRequest{}, params) :: %ApiRequest{} 
  defp add_signature(api_request, params) do
    url_query = params 
                |> sort 
                |> url_encode
    md5_hash = :crypto.hash(:md5, url_query) 
               |> Base.encode16()
               |> String.downcase
    hmac_data = if api_request.method == :post, do: "POST#", else: "GET#"
    hmac_data = hmac_data
                <> (Application.get_env(:bitcoin_de, :server) |> Map.fetch!(:host))
                <> api_request.path
                <> "#"
                <> (Application.get_env(:bitcoin_de, :credentials) |> Map.fetch!(:key))
                <> "#"
                <> (api_request.nonce |> Kernel.inspect)
                <> "#"
                <> md5_hash
    signature = Application.get_env(:bitcoin_de, :credentials)
                |> Map.fetch!(:secret)
                |> (&(:crypto.hmac(:sha256, &1, hmac_data))).()
                |> Base.encode16

    %ApiRequest{api_request | url_query: url_query, signature: signature}
  end

  defp nonce() do
    :os.system_time(:millisecond)
  end

  @spec create_trade(atom, number, number) :: {integer, %ApiRequest{}}
  def create_trade(type, max_amount, price) do
    params = [type: type, max_amount: (max_amount / 1), price: (price / 1)]  
    %ApiRequest{method: :post, path: "/v1/orders", nonce: nonce()} |> add_signature(params)
  end
end
