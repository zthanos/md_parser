defmodule LineTokenizer do
  def parse_line(line) do
    init_line = %BlockTokenizer.Line{original: line, elements: []}
    apply_tokenization_rules(line, tokenization_rules(), init_line)
  end

  # defp apply_tokenization_rules(line, [], []) do
  #   [%{attribute: :normal, value: line}]
  # end

  defp apply_tokenization_rules("", _tokenization_rules, tokenizedline) do
    tokenizedline

  end

  defp apply_tokenization_rules(line, [regex | rest], tokenizedline) do
    value =
      case Regex.run(regex.pattern, line) do
        nil -> nil
        [val | more] ->
          clean = case more do
            [_, cl, _] -> cl
            _ -> val
          end
          clean |> dbg()
          # [_, clean, _] = more
          # clean |> dbg()
          %{value: val, clean: clean}

      end

      case value do
        nil ->
          apply_tokenization_rules(line, rest, tokenizedline)

        _ ->
          element = %BlockTokenizer.Line.LineElement{attribute: regex.rule, value: value.clean}
          remaining = String.trim(String.replace(line, value.value, ""))
          apply_tokenization_rules(remaining, tokenization_rules(), BlockTokenizer.Line.append_element(tokenizedline, element))
      end

    #   element = %BlockTokenizer.Line.LineElement{attribute: regex.rule, value: value}

    # remaining = String.trim(String.replace(line, value, ""))
    # # remaining |> dbg()

    # apply_tokenization_rules(remaining, tokenization_rules(), BlockTokenizer.Line.append_element(tokenizedline, element))
  end

  # defp apply_tokenization_rules(line, [regex | rest], acc) do
  #   case Regex.run(regex.pattern, line) do
  #     [token | [_, val, _]] ->
  #       remaining = String.trim_leading(line, token) |> String.trim_leading()
  #       new_acc = acc ++ %{attribute: Atom.to_string(regex.rule), value: val}
  #       apply_tokenization_rules(remaining, tokenization_rules(), new_acc)

  #     [val | _rest] ->
  #       remaining = String.trim_leading(line, val) |> String.trim_leading()
  #       token = %{attribute: Atom.to_string(regex.rule), value: val}
  #       apply_tokenization_rules(remaining, tokenization_rules(),  [token | acc])
  #     _ ->
  #         apply_tokenization_rules(line, rest, acc)
  #   end
  # end

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
      # %{pattern: ~r/[^~]+|(?<=\s)(?=\S)/, rule: :normal},
      # %{pattern: ~r/([^*_~]+|(?<=\s)[*_~](?=\S))/, rule: :normal},
      %{pattern: ~r/(.*)/, rule: :normal}

      # Add more regex patterns for additional tokenization rules
    ]
  end
end
