defmodule Tokenizer do
  def parse(text) do
    lines = String.split(text, "\n")
    # lines |> dbg()
    tokenize_lines(lines, [])
    String.Tokenizer.tokenize(lines) |> dbg()
  end

  def tokenize_lines([], acc) do
    # acc |> dbg()
    Enum.reverse(acc)
  end

  def tokenize_lines([line | rest], acc) do
    level = 0

    # line |> dbg()
    tokenize_lines(rest, acc ++ [parse_line(line, level)])


  end

  def parse_line("", level) do
    IO.puts("emty line")

    {:empty_line, level, ""}
  end

  def parse_line(nil, level) do
    IO.puts("nil line")
    {:empty_line, level, ""}
  end

  def parse_line(line, _level) do
    IO.puts("process line")
    line
    |> parse_header()

    # content = line # String.slice(line, 1, String.length(line))
    # content
    # case String.first(line) do
    #   "" -> {:paragraph, level, line}
    #   "#" -> {:header, level, content}
    #   "*" -> {:formatter, level, content}
    #   "-" -> {:formatter, level, content}
    #   "_" -> {:formatter, level, content}
    #   "`" -> {:code, level, content}
    #   "!" -> {:image, level, content}
    #   "[" -> {:link, level, content}
    #   "|" -> {:table, level, content}
    #   "=" -> {:formatter, level, content}
    #   "H" -> {:formatter, level, content}
    #   "X" -> {:formatter, level, content}
    #   _ ->  {:paragraph, level, line}
    # end
  end



  defp parse_header(line) do
    Regex.scan(headers(), line) |> dbg()
    result = Regex.scan(headers(), line)

    case result do
      [[] | _tail] -> line
      [head | _tail] -> [_, level, content] = head
        {:header, level, content}
    end
  end
defp headers, do: ~r/(\#{1,6})\s+(.*)/

end
