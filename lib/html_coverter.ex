defmodule HtmlCoverter do
  def convert(tokenized) do
    html =
      Enum.reduce(tokenized, "", fn x, acc ->
        acc <> process(x)
      end)

    "<html>\n<body>\n#{html}\n</body>\n</html>"
  end

  defp process(%BlockTokenizer.Block{block_type: :paragraph_block} = block) do
    text =
      Enum.reduce(List.first(block.content).elements, "", fn x, acc ->
        case x.attribute do
          :bold -> acc <> "<strong>#{x.value}</strong>"
          :italic -> acc <> "<i>#{x.value}</i>"
          _ -> acc <> x.value
        end
      end)

    "<p>\n#{text}\n</p>"
  end

  defp process(%BlockTokenizer.Block{block_type: :unordered_list_block} = block) do
    rows =
      Enum.reduce(block.content, "", fn r, acc ->
        value =
          Enum.reduce(r, "", fn x, acc ->
            acc <> format_line(x.attribute, x.value)
          end)

        acc <> "<li>\n#{value}\n</li>"
      end)

    "<ul>\n#{rows}\n</ul>"
  end

  defp process(%BlockTokenizer.Block{block_type: :header} = block) do
    "<h#{block.level}>#{block.content}</h#{block.level}>"
  end

  defp process(%BlockTokenizer.Block{block_type: _} = _block) do
    "    "
  end

  defp format_line(attribute, value) do
    case attribute do
      :bold -> "<strong>#{value}</strong>"
      :italic -> "<em>#{value}</em>"
      :strikethrough -> "<s>#{value}</s>"
      _ -> value
    end
  end
end
