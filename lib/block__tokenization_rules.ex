defmodule BlockTokenizationRules do
  def tokenization_rules do
    [
      # %{rule: ~r/^\#{1,6}/, attr: :bold},       # Bold
      %{rule: ~r/^\#{1,6}\s+/, name: :header_block},
      %{rule: ~r/^- /, name: :paragraph_block}
    ]
  end
end
