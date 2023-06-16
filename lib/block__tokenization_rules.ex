defmodule BlockTokenizationRules do
  def tokenization_rules do
    [
      %{rule: ~r/^\#{1,6}\s+/, name: :header_block},
      %{rule: ~r/(_{3}|-{3}|\*{3})\s*/, name: :horizontal_ruler_block},

      #keep that line last
      %{rule: ~r/(.*)(\r)/, name: :paragraph_block}

    ]
  end
end
