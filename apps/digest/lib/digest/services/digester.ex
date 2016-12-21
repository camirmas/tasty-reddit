defmodule Digest.Services.Digester do
  @callback process(list(map), keyword) :: list(map)

  defmodule Envelope do
    defstruct [
      :title,
      :link,
      :summary,
      :sub,
    ]
  end
end
