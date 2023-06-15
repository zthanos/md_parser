defmodule BlockTokenizer do

  def tokenize_lines([], acc) do
    Enum.reverse(acc)
  end

  def parse_block(lines, acc) do
    lines |> dbg()
    tokens = apply_tokenization_rules(lines, tokenization_rules())
    {:document, acc ++ [tokens]}
  end

  def tokenize_lines([], _block_rules, acc) do
    Enum.reverse(acc)
  end

  def tokenize_lines([line | rest], block_rules, acc) do
    case Enum.find_value(block_rules, fn rule -> rule(line) end) do
      {:ok, block} ->
        tokenize_lines(rest, block_rules, [block | acc])
      :continue ->
        tokenize_lines(rest, block_rules, acc)
      _ ->
        {paragraph, line} = parse_line(line)
        tokenize_lines(rest, block_rules, [paragraph | acc])
    end
  end


  defp parse_line(line) do
    # Perform tokenization within paragraphs or other elements
    tokens = line
    |> String.split(~r/ (\*{2}|_{2})(.*)(\*{2}|_{2})/, trim: true)
    |> String.split(~r/\s+/, trim: true)
    {:paragraph, tokens}
  end

  defp rule(line) do
    line
    # Implement the rule logic here
  end

  def block_tokenization_rules do
    [
      &parse_header/1,       # Header
      &parse_list_item/1,    # List Item
      # Add more block tokenization rules
    ]
  end

  defp parse_header(line) do
    # Logic to parse header and extract level and content
    line
  end

  defp parse_list_item(line) do
    # Logic to parse list item and extract content
    line
  end
  # def parse_block([], acc) do
  #   acc
  # end

  # def parse_block([line | rest], acc) do
  #   cond do
  #     String.match?(line, ~r/^\#{1,6}\s+/) -> parse_header(line, rest, acc)
  #     String.match?(line, ~r/^- /) -> parse_list_item(line, rest, acc)
  #     true -> parse_block(rest, acc ++ [line])
  #   end
  # end

  defp apply_tokenization_rules(line, []) do
    [line]
  end

  defp apply_tokenization_rules([line, rest], [regex | rest]) do
    line |> dbg()
    case Regex.run(regex.rule, line) do
      [_token | [_, val, _]] ->
        val |> dbg()
        [Atom.to_string(regex.attr) | apply_tokenization_rules(val, rest)]
      _ ->
        apply_tokenization_rules(line, rest)
    end
    apply_tokenization_rules(rest, [])
  end

  def tokenization_rules do
    [
      # %{rule: ~r/^\#{1,6}/, attr: :bold},       # Bold
      %{rule: ~r/^\#{1,6}\s+/, name: :header_block},
      %{rule: ~r/^- /, name: :paragraph_block}
    ]
  end

  # defp parse_header(line, rest, acc) do
  #   level = String.length(String.trim_trailing(line, "#"))
  #   parse_block(rest, acc ++ [{:header, level, String.trim_leading(line, "#")}])
  # end

  # defp parse_list_item(line, rest, acc) do
  #   parse_block(rest, acc ++ [:list_item, String.trim_leading(line, "- ")])
  # end
end
