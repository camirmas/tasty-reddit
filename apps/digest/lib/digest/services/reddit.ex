defmodule Digest.Services.Reddit do
  @behaviour Digest.Services.Digester

  alias Digest.Services.Digester.Summary

  @doc """
  Function responsible for processing the data coming back from the
  designated source. The returned data is fully digested and ready
  to be sent.
  """
  def process(data, opts \\ []) do
    data
    |> parse
    |> dedupe
    |> filter(opts)
    |> digest(opts)
  end

  @doc """
  Parses the data and returns it as a Map.
  """
  def parse(data) do
    data
    |> Poison.Parser.parse!
    |> Kernel.get_in(["data", "children"])
  end

  @doc """
  Checks for duplicates, if applicable, and filters them out.
  """
  def dedupe(data) do
    Enum.uniq_by(data, fn resp ->
      Kernel.get_in(resp, ["data", "id"])
    end)
  end

  @doc """
  Filters the data by any given parameters.
  """
  def filter(data, opts) do
    data
  end

  @doc """
  Creates readable summaries of the given data.
  """
  def digest(data, opts) do
    Enum.map(data, fn item ->
      item
      |> Kernel.get_in(["data"])
      |> Map.take(["title", "url", "subreddit"])
      |> create_summary_struct
    end)
  end

  defp create_summary_struct(map) do
    map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
    struct(Summary, map)
  end
end
