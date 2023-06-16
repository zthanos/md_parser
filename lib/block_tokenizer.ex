defmodule BlockTokenizer do
  def tokenize_lines([], acc) do
    Enum.reverse(acc)
  end

  def parse_block(lines, block_rules, acc) do
    block_tokens = apply_tokenization_rules(lines, block_rules)
    {:document, acc ++ [block_tokens]}
  end

  def tokenize_lines([], _block_rules, acc) do
    Enum.reverse(acc)
  end

  def tokenize_lines([line | rest], block_rules, acc) do
    cond do
      String.starts_with?(line, "\r") ->
        tokenize_lines(rest, block_rules, acc)

      String.length(String.trim(line)) == 0 ->
        tokenize_lines(rest, block_rules, acc)

      true ->
        block = apply_tokenization_rules(line, block_rules)
        tokenize_lines(rest, block_rules, [{block, rest} | acc])
    end
  end

  defp apply_tokenization_rules(line, [rule | rest]) do
    line |> dbg()
    Regex.run(rule.rule, line) |> dbg()

    if Regex.run(rule.rule, line) do
      parse_block1(rule.name, line)
    else
      apply_tokenization_rules(line, rest)
    end
  end

  defp parse_block1(:header_block, line) do
    line |> dbg()
    stripped = String.trim_leading(line, "#")

    level = String.length(line) - String.length(stripped)
    [{:header, level, stripped}]
  end

  defp parse_block1(:paragraph_block, line) do
    line |> dbg()
    [{:paragraph_block, line}]
  end
end
