defmodule BitcoinDe.ApiRequest do
  defstruct [:method, :path, :uri, :url_query, :nonce, :signature]
end
