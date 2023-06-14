defmodule MdDocument do
  def parse(text) do
    lines = String.split(text, "\n")
    parse_blocks(lines, [])
  end

  def parse_blocks([], acc) do
    Enum.reverse(acc)
  end


  def parse_blocks(["```" | rest], acc) do
    code_lines = extract_code_block(rest, [])
    parse_blocks(code_lines, acc ++ [:code_block | code_lines])
  end

  def parse_blocks([line | rest], acc) do
    cond do
      String.match?(line, ~r/^\#{1,6}\s+/) -> parse_header(line, rest, acc)
      String.match?(line, ~r/^- /) -> parse_list_item(line, rest, acc)
      true -> parse_blocks(rest, acc ++ [parse_line(line)])
    end
  end


  defp parse_header(line, rest, acc) do
    level = String.length(String.trim_trailing(line, "#"))
    parse_blocks(rest, acc ++ [{:header, level, String.trim_leading(line, "#")}])
  end

  defp parse_list_item(line, rest, acc) do
    parse_blocks(rest, acc ++ [:list_item, String.trim_leading(line, "- ")])
  end
  def parse_line(line) do
    # Perform tokenization within paragraphs or other elements
    tokens = line |> String.split(~r/\s+/, trim: true)
    {:paragraph, tokens}
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
