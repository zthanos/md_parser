defmodule LineTokenizer do
  def parse_line(line) do
    tokens = apply_tokenization_rules(line, tokenization_rules(), [])
    tokens
  end

  defp apply_tokenization_rules(line, [], []) do
    [%{attribute: :normal, value: line}]
  end

  defp apply_tokenization_rules(line, [regex | rest], acc) do
    case Regex.run(regex.pattern, line) do
      [token | [_, val, _]] ->
        remaining = String.trim_leading(line, token) |> String.trim_leading()
        new_acc = acc ++ [%{attribute: Atom.to_string(regex.rule), value: val}]
        apply_tokenization_rules(remaining, tokenization_rules(), new_acc)

      [val | _rest] ->
        remaining = String.trim_leading(line, val) |> String.trim_leading()

        new_acc = acc ++ [%{attribute: Atom.to_string(regex.rule), value: val}]
        apply_tokenization_rules(remaining, tokenization_rules(), new_acc)

      _ ->
        if String.length(line) > 0 do
          apply_tokenization_rules(line, rest, acc)
        else
          acc
        end


    end
  end

  defp tokenization_rules do
    [

      # Bold
      %{pattern: ~r/^(\*{2})(.*?)(\1)/, rule: :bold},
      # Bold
      %{pattern: ~r/^(_{2})(.*?)(\1)/, rule: :bold},
      # Italic
      %{pattern: ~r/^(_{1})(.*?)(\1)/, rule: :italic},
      # Italic
      %{pattern: ~r/^(\*{1})(.*?)(\1)/, rule: :italic},
      # Strikethrough
      %{pattern: ~r/^(~~)(.*?)(\1)/, rule: :strikethrough},
      # Normal text
      %{pattern: ~r/([^*_~]+|(?<=\s)[*_~](?=\S))/, rule: :normal}

      # Add more regex patterns for additional tokenization rules
    ]
  end
end
