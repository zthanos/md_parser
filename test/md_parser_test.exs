defmodule MdParserTest do
  use ExUnit.Case
  doctest MdParser



  test "test tokenizer" do
    {:ok, doc} = File.read("./assets/data/paragraphed.md")
    parsed = MdDocument.tokenize(doc)
    parsed |> dbg()
    html = HtmlCoverter.convert(parsed)
    File.write("response.html", html)
    assert parsed != nil
  end


end
