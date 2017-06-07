defmodule BitcoinDe.Credentials do
  @enforce_keys [:key, :secret]
  defstruct [:key, :secret]
end
