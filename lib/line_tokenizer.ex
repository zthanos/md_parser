defmodule LineTokenizer do

  def parse_line(line) do
    tokens = apply_tokenization_rules(line, tokenization_rules())
    {:paragraph, tokens}
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
      %{rule: ~r/(\*{2})(.*?)(\1)/, attr: :bold},       # Bold
      %{rule: ~r/(_{2})(.*?)(\1)/, attr: :Bold},        # Bold
      %{rule: ~r/(_{1})(.*?)(\1)/, attr: :Bold},        # Italic
      %{rule: ~r/(\*{1})(.*?)(\1)/, attr: :italic},     # Italic
      %{rule: ~r/(~~)(.*?)(\1)/, attr: :strikethrough}, # Strikethrough
      # Add more regex patterns for additional tokenization rules
    ]
  end


end
