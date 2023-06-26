defmodule BlockTokenizer.Block do
  defstruct [:block_type, :level, :content, :supports_nested]

  use ExConstructor

  def header(level, content) do
    %__MODULE__{block_type: :header, level: level, content: content}
  end

  def create(block_type, level, content) do
    %__MODULE__{block_type: block_type, level: level, content: [content]}
  end

  def create_ordered(block_type, level, content) do
    %__MODULE__{block_type: block_type, level: level, content: content}
  end

  def append_content(block, content) do
    %__MODULE__{
      block
      | content: content <> content
    }
  end

  def append_content1(block, new_content) do
    %__MODULE__{
      block
      | content: block.content ++ [new_content]
    }
  end

  def supports_nested?(block) do
    block.block_type in ~w[paragraph_block ordered_list_block unordered_list_block blockquote_block]a
  end
end
