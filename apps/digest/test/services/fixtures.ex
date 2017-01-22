defmodule Services.Fixtures do
  def get_responses() do
    resp_json = File.read!("test/services/fixtures.json")
    [{:ok, %{body: resp_json}}]
  end
end
