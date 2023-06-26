defmodule BlockTokenizer do
  def tokenize_lines([], acc) do
    Enum.reverse(acc)
  end

  def tokenize_blocks(lines, block_rules, acc) do
    block_tokens = tokenize_lines(lines, block_rules, [])
    {:document, acc ++ block_tokens}
  end

  def tokenize_lines([], _block_rules, acc) do
    Enum.reverse(acc)
  end

  def tokenize_lines([line | rest], block_rules, acc) do
    block = identify_block(line, block_rules)

    previous_section = List.first(acc)

    section =
      case BlockTokenizer.Block.supports_nested?(block) and is_nested_block?(block, previous_section) do
        false -> [block | acc]
        true -> update_section(block, previous_section, acc)
      end

    tokenize_lines(rest, block_rules, section)
  end

  defp is_nested_block?(_block, nil), do: false

  defp is_nested_block?(block, previous_block) do
    block.block_type == previous_block.block_type
  end

  defp update_section(block, previous_block, section) do
      case block.block_type do
        :blockquote_block ->


              updated_previous_section = add_block_to_level(previous_block, block)
              updated_previous_section

        :unordered_list_block ->
            if block.level == previous_block.level do
              updated_previous_section =
                BlockTokenizer.Block.append_content1(previous_block, List.first(block.content))

              list = List.replace_at(section, 0, updated_previous_section)
              list

            else
              section ++ block
            end


        :ordered_list_block ->
          [block]

        :paragraph_block ->
          if previous_block.block_type == :paragraph_block do
            updated_previous_section =
              BlockTokenizer.Block.append_content(previous_block, List.first(block.content))

            Map.put(previous_block, :content, updated_previous_section)

            # [updated_previous_section | List.delete_at(acc, 0)]
          else
            [block]
          end
      end
  end

  def add_block_to_level(section, block) do
    updated_content = Map.get(section, :content, []) ++ block
    Map.put(section, :content, updated_content)
  end

  defp identify_block(line, block_rules) do
    cond do
      String.starts_with?(line, "\r") -> BlockTokenizer.Block.create(:empty_line, 1, "")
      String.length(String.trim(line)) == 0 -> BlockTokenizer.Block.create(:empty_line, 1, "")
      true -> apply_tokenization_rules(line, block_rules)
    end
  end

  defp apply_tokenization_rules(line, []) do
    BlockTokenizer.Block.create(:unknown, 1, line)
  end

  defp apply_tokenization_rules(line, [rule | rest]) do
    if Regex.run(rule.rule, line) do
      parse_block(rule.name, line)
    else
      apply_tokenization_rules(line, rest)
    end
  end

  defp parse_block(:header_block, line) do
    stripped = String.trim_leading(line, "#")

    level = String.length(line) - String.length(stripped)
    BlockTokenizer.Block.header(level, stripped)
    # {:header, level, stripped}
  end

  defp parse_block(:paragraph_block, line) do
    tokenized = LineTokenizer.parse_line(line)
    # BlockTokenizer.Block.create(:paragraph_block, 1, tokenized)
    BlockTokenizer.Block.create(:paragraph_block, 1, tokenized)
  end

  defp parse_block(:horizontal_ruler_block, _line) do
    BlockTokenizer.Block.create(:horizontal_ruler_block, 0, "")
    # {:horizontal_ruler_block, ""}
  end

  defp parse_block(:blockquote_block, line) do
    remaining = String.trim(line)
    {content, level} = parse_nested_blockquotes(remaining, 0)
    BlockTokenizer.Block.create(:blockquote_block, level, content)
    # {:blockquote_block, level, content}
  end

  defp parse_block(:unordered_list_block, line) do
    case String.match?(line, ~r/[\+|\-|\*]/) do
      true ->
        level =
          case Regex.run(~r/\s+[\+|\-|\*]/, line) do
            nil -> 1
            [indentation | _rest] -> calculate_level(indentation)
          end

        content =
          line
          |> String.trim_leading()
          |> String.slice(1, String.length(line))
          |> String.trim()
        tokenized_line = LineTokenizer.parse_line(content)

        # tokenized = List.first(LineTokenizer.parse_line(content))
        # tokenized = LineTokenizer.parse_line(content)
        # BlockTokenizer.Block.create_ordered(:unordered_list_block, level, tokenized)
         BlockTokenizer.Block.create(:unordered_list_block, level, tokenized_line.elements)

      false ->
        # {:unordered_list_block, 1, line}
        BlockTokenizer.Block.create(:unordered_list_block, 1, line)
    end
  end

  defp parse_block(:ordered_list_block, line) do
    # {:ordered_list_block, line}
    BlockTokenizer.Block.create(:ordered_list_block, 1, line)
  end

  defp parse_block(_, line) do
    BlockTokenizer.Block.create(:unknown, 1, line)
  end

  defp calculate_level(indentation) do
    round(String.length(indentation) / 2)
  end

  defp parse_nested_blockquotes(line, level) do
    case String.match?(line, ~r/>/) do
      false ->
        {line, level}

      true ->
        [_blockquote | rest] = String.split(line, ">", parts: 2)
        {nested_content, nested_level} = parse_nested_blockquotes(List.first(rest), level + 1)
        {nested_content, nested_level}
    end
  end
end
