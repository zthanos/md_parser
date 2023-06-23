defmodule MdDocument do
  def tokenize(text) do
    lines = String.split(text, "\n")

    {_, blocks} =
      BlockTokenizer.tokenize_blocks(lines, BlockTokenizationRules.tokenization_rules(), [])
    blocks
  end

end
