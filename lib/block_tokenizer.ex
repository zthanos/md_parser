defmodule BlockTokenizer do
  def parse_block([line | _rest]) do
    blocks = apply_tokenization_rules(line, tokenization_rules())
    {:doc, blocks}
  end

  defp apply_tokenization_rules(line, []) do
    [line]
  end

  defp apply_tokenization_rules(line, [regex | rest]) do
    case Regex.run(regex.rule, line) do
      [_token | [_, val, _]] ->
        [Atom.to_string(regex.attr) | apply_tokenization_rules(val, rest)]
      _ ->
        apply_tokenization_rules(line, rest)
    end
  end

  defp tokenization_rules do
    [
      %{rule: ~r/^\#{1,6}/, attr: :bold},       # Bold

    ]
  end

end
