defmodule MdParserTest do
  use ExUnit.Case
  doctest MdParser

  test "test tokenizer" do
    {:ok, doc} = File.read("./assets/data/sample.md")
    Tokenizer.parse(doc)
    assert true
  end
  test "greets the world" do
    assert MdParser.hello() == :world
  end
end
