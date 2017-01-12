defmodule EmailTest do
  use ExUnit.Case

  @digest [%{url: "url", title: "title", subreddit: "subreddit"}]

  test "generate_template/2 generates the email template" do
    assert Email.generate_template(@digest)
  end
end
