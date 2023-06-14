defmodule MdParserTest do
  use ExUnit.Case
  doctest MdParser
@headers """
# h1 Heading 8-)
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading

"""
  test "test tokenizer" do
    {:ok, doc} = File.read("./assets/data/sample.md")
    # Tokenizer.parse(doc)
    parsed = MdDocument.parse(doc)
    # parsed |> dbg()
    assert true
  end

  test "test headers" do
    parsed_blocks = MdDocument.parse(@headers)
    html = MdDocument.to_html(parsed_blocks)
    parsed_blocks |> dbg()
    assert true
  end

  test "greets the world" do
    assert MdParser.hello() == :world
  end
end
