defmodule MdParserTest do
  use ExUnit.Case
  doctest MdParser


  # test "test Line tokenizer" do
  #   text = """
  #   **Bold** Use double asterisks or underscores (`**text**` or `__text__`).
  #   """
  #   parsed = LineTokenizer.parse_line(text)
  #   parsed |> dbg()
  #   # html = HtmlCoverter.convert(parsed)
  #   # File.write("response.html", html)
  #   assert parsed != nil
  # end


  test "test tokenizer" do
    {:ok, doc} = File.read("./assets/data/paragraphed.md")
    parsed = MdDocument.tokenize(doc)
    parsed |> dbg()
    html = HtmlCoverter.convert(parsed)

    File.write("response.html", html)
    assert parsed != nil
  end


end
