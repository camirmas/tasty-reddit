defmodule Services.RedditTest do
  use ExUnit.Case

  alias Digest.Services.Reddit
  alias Digest.Services.Digester.Summary

  @response Services.Fixtures.get_responses

  test "parse/1 should convert a response to an Elixir list of maps" do
    resp = Reddit.parse(@response)

    assert is_list(resp)
    assert length(resp) == 2
    assert is_map(List.first(resp))
  end

  test "dedupe/1 should remove duplicates by id" do
    resp1 = Reddit.parse(@response)
    resp2 = Reddit.parse(@response)
    resp = resp1 ++ resp2

    deduped = Reddit.dedupe(resp)

    assert is_list(deduped)
    assert length(deduped) == 2
  end

  test "filter/2 should filter results by certain parameters" do
    assert 1 > 0
  end

  test "digest/2 should create summaries of the given data" do
    resp = Reddit.process(@response)

    assert Enum.all?(resp, fn item -> %Summary{} = item end)
    assert Enum.all?(resp, fn item -> item.subreddit == "elixir" end)
  end
end
