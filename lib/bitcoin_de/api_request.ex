defmodule BitcoinDe.ApiRequest do
  defstruct [:method, :path, :uri, :nonce, :signature]
end
