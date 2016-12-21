defmodule Services.Fixtures do
  def get_responses() do
    File.read!("test/services/fixtures.json")
  end
end
