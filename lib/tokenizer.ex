defmodule MdDocument do


  def tokenize(text) do
    lines = String.split(text, "\n")
    blocks = BlockTokenizer.tokenize_lines(lines, BlockTokenizationRules.tokenization_rules(), [])
    blocks
  end
  # def parse_blocks([], acc) do
  #   Enum.reverse(acc)
  # end


  # def parse_blocks(["```" | rest], acc) do
  #   code_lines = extract_code_block(rest, [])
  #   parse_blocks(code_lines, acc ++ [:code_block | code_lines])
  # end

  # def parse_blocks([line | rest], acc) do
  #   cond do
  #     String.match?(line, ~r/^\#{1,6}\s+/) -> parse_header(line, rest, acc)
  #     String.match?(line, ~r/^- /) -> parse_list_item(line, rest, acc)
  #     true -> parse_blocks(rest, acc ++ [parse_line(line)])
  #   end
  # end


  # defp parse_header(line, rest, acc) do
  #   level = String.length(String.trim_trailing(line, "#"))
  #   parse_blocks(rest, acc ++ [{:header, level, String.trim_leading(line, "#")}])
  # end

  # defp parse_list_item(line, rest, acc) do
  #   parse_blocks(rest, acc ++ [:list_item, String.trim_leading(line, "- ")])
  # end

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


  def extract_code_block(["```" | _rest], code_lines) do
    Enum.reverse(code_lines)
  end

  def extract_code_block([line | rest], code_lines) do
    extract_code_block(rest, [line | code_lines])
  end

  def to_html(parsed_blocks) do
    parsed_blocks
    |> Enum.map(&convert_block_to_html/1)
    |> List.flatten()
    |> List.to_string()
  end

  defp convert_block_to_html(:code_block) do
    "<pre><code>"
  end

  defp convert_block_to_html(block) do
    case block do
      {:header, _level, content} -> content |> dbg()
      {:paragraph, tokens} ->
        tokens
        |> Enum.map(&convert_token_to_html/1)
        |> List.flatten()
        |> List.to_string()
    end
  end

  defp convert_token_to_html(token) do
    "<span>" <> token <> "</span>"
  end
end


# defmodule Tokenizer1 do
#   def parse(text) do
#     lines = String.split(text, "\n")
#     # lines |> dbg()
#     tokenize_lines(lines, [])
#     String.Tokenizer.tokenize(lines) |> dbg()
#   end

#   def tokenize_lines([], acc) do
#     # acc |> dbg()
#     Enum.reverse(acc)
#   end

#   def tokenize_lines([line | rest], acc) do
#     level = 0

#     # line |> dbg()
#     tokenize_lines(rest, acc ++ [parse_line(line, level)])


#   end

#   def parse_line("", level) do
#     IO.puts("emty line")

#     {:empty_line, level, ""}
#   end

#   def parse_line(nil, level) do
#     IO.puts("nil line")
#     {:empty_line, level, ""}
#   end

#   def parse_line(line, _level) do
#     IO.puts("process line")
#     line
#     |> parse_header()

#     # content = line # String.slice(line, 1, String.length(line))
#     # content
#     # case String.first(line) do
#     #   "" -> {:paragraph, level, line}
#     #   "#" -> {:header, level, content}
#     #   "*" -> {:formatter, level, content}
#     #   "-" -> {:formatter, level, content}
#     #   "_" -> {:formatter, level, content}
#     #   "`" -> {:code, level, content}
#     #   "!" -> {:image, level, content}
#     #   "[" -> {:link, level, content}
#     #   "|" -> {:table, level, content}
#     #   "=" -> {:formatter, level, content}
#     #   "H" -> {:formatter, level, content}
#     #   "X" -> {:formatter, level, content}
#     #   _ ->  {:paragraph, level, line}
#     # end
#   end



#   defp parse_header(line) do
#     Regex.scan(headers(), line) |> dbg()
#     result = Regex.scan(headers(), line)

#     case result do
#       [[] | _tail] -> line
#       [head | _tail] -> [_, level, content] = head
#         {:header, level, content}
#     end
#   end
# defp headers, do: ~r/(\#{1,6})\s+(.*)/

# end
