defmodule Digest.Services.Digester do
  @callback process(list(map), keyword) :: list(Summary.t)

  defmodule Summary do
    defstruct [
      :title,
      :url,
      :subreddit,
    ]
  end
end
