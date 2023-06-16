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

@typographic """
## Emphasis

**This is bold text**
 and this should be int the same block

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~

this is the normal text section

"""
  # test "test tokenizer" do
  #   {:ok, doc} = File.read("./assets/data/sample.md")
  #   # Tokenizer.parse(doc)
  #   parsed = MdDocument.parse(doc)
  #    parsed |> dbg()
  #   assert true
  # end

  # test "test headers" do
  #   parsed_blocks = MdDocument.tokenize(@typographic)
  #   # _html = MdDocument.to_html(parsed_blocks)
  #   parsed_blocks |> dbg()
  #   assert true
  # end


  test "simple test with  header and paragraph" do
    text = """
    ## This is the header

    and here is the first paragraph from the test
    with soft return

    and there is the secondp paragraph block
    containing lorem ipsum
    """

    parsed_blocks = MdDocument.tokenize(text)
    # _html = MdDocument.to_html(parsed_blocks)
    parsed_blocks |> dbg()
    assert true
  end
  test "greets the world" do
    assert MdParser.hello() == :world
  end
end
