defmodule MessageBrokerTest do
  use ExUnit.Case
  doctest MessageBroker

  test "greets the world" do
    assert MessageBroker.hello() == :world
  end
end
