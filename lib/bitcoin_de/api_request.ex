defmodule BitcoinDe.ApiRequest do
  defstruct [:method, :path, :url_query, :nonce, :signature]
end
