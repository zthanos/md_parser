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
      Enum.reduce(block.content, "", fn x, acc ->
        case x.attribute do
          :bold -> acc <> "<strong>#{x.value}</strong>"
          _ -> acc <> x.value
        end
      end)

    "<p>\n#{text}\n</p>"
  end

  defp process(%BlockTokenizer.Block{block_type: :unordered_list_block} = block) do
    text =
      Enum.reduce(block.content, "", fn x, acc ->
        case x do
          [sub_item | _] ->
            acc <> "<li>#{sub_item}</li>"
          _ ->
            acc <> "<li>#{format_content(x)}</li>"
        end
      end)

    "<ul>\n#{text}\n</ul>"
  end


  defp process(%BlockTokenizer.Block{block_type: :header} = block) do
    "<h#{block.level}>#{block.content}</h#{block.level}>"
  end

  defp process(%BlockTokenizer.Block{block_type: _} = _block) do
    "    "
  end

  defp format_content(text) do
    text |> dbg()
    text
    # Enum.reduce(text, "", fn x, acc ->
    #   case x.attribute do
    #     :bold -> acc <> "<strong>#{x.value}</strong>"
    #     _ -> acc <> x.value
    #   end
    # end)
  end
end
