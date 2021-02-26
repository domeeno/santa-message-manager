defmodule MessageProcessingTest do
  use ExUnit.Case
  doctest MessageProcessing

  test "greets the world" do
    assert MessageProcessing.hello() == :world
  end
end
