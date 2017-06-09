defmodule BitcoinDeTest do
  use ExUnit.Case

  setup_all do
    {:ok, pid: 
      BitcoinDe.start_link(self(), struct(BitcoinDe.Credentials, Application.get_env(:bitcoin_de, :credentials)))
    }
  end

  @tag :skip
  test "show public trade history", state do
    {:ok, pid} = state[:pid] 
    {:ok, _} = GenServer.call(pid, {:show_public_trade_history}, 10000)
  end

  test "show orderbook", state do
    {:ok, pid} = state[:pid]
    {:ok, _} = GenServer.call(pid, {:show_orderbook, [:buy]}, 10000)
  end
end
