defmodule BitcoinDeTest do
  use ExUnit.Case
  doctest BitcoinDe

  test "start link with invalid credentials" do
    {:err, message} = BitcoinDe.start_link(self(), %BitcoinDe.Credentials{key: "xxxxx", secret: "cccccc"})
    assert message == "Invalid credentials" 
  end
end
