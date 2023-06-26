defmodule BlockTokenizer.Line do
  defstruct ~w[original elements]a

  defmodule LineElement do
    defstruct ~w[attribute value]a
  end

  def append_element(%__MODULE__{} = line, %LineElement{} = element) do
    %__MODULE__{line | elements: Enum.reverse([element | line.elements])}
  end
end
