defmodule BlockTokenizer do
  def tokenize_lines([], acc) do
    Enum.reverse(acc)
  end

  def parse_block(lines, block_rules, acc) do
    tokens = apply_tokenization_rules(lines, block_rules)
    {:document, acc ++ [tokens]}
  end

  def tokenize_lines([], _block_rules, acc) do
    Enum.reverse(acc)
  end



  def tokenize_lines([line | rest], block_rules, acc) do
    case Enum.find_value(block_rules, fn rule -> rule(line, rule) end) do
      {:ok, :new_block, rule} ->
        tokenize_lines(rest, block_rules, [line | acc])

      :continue ->
        tokenize_lines(rest, block_rules, acc)

      _ ->
        {block, line, _rule} = LineTokenizer.parse_line(line)
        tokenize_lines(rest, block_rules, [{block, line} | acc])
    end
  end

    defp rule(line, rule) do
      cond do
        String.starts_with?("/r", line) -> :continue
        String.starts_with?(" ", line) -> {:ok, :new_block, rule}
        true -> {:ok, :existing_block, rule}
      end
  end

  defp apply_tokenization_rules(line, rule) do
    if Regex.run(rule.rule, line) do
          parse_block1(rule.name, line)
      #     {:ok, {rule.name, content}}
    else
    line
    end
    # Implement your tokenization rules here
    # and return the tokenized result
  end




  defp apply_tokenization_rules(line, []) do
    [line]
  end

    defp parse_block1(:header_block, line) do
    # Logic to parse header and extract level and content
    line |> dbg()
    stripped = String.trim_leading(line, "#")

    level = String.length(line) - String.length(stripped)
    [{:header, level, stripped}]
  end
end




    # def tokenize_lines([line | rest], block_rules, acc) do
  #   case Enum.find_value(block_rules, fn rule -> rule(rule, line) end) do
  #     {:ok, block} ->
  #       tokenize_lines(rest, block_rules, [block | acc])

  #     :continue ->
  #       tokenize_lines(rest, block_rules, acc)

  #     _ ->
  #       {block, line} = LineTokenizer.parse_line(line)
  #       tokenize_lines(rest, block_rules, [{block, line} | acc])
  #   end
  # end

  # defp rule(rule, line) do
  #   if Regex.run(rule.rule, line) do
  #     content = parse_block1(rule.name, line)
  #     {:ok, {rule.name, content}}
  #   end

  # end
