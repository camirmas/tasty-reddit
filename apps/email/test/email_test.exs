defmodule EmailTest do
  use ExUnit.Case, async: true
  use Bamboo.Test

  @digest [%{url: "url", title: "title", subreddit: "subreddit"}]
  @user %{email: "vader@deathstar.net"}

  test "generate_template/2 generates the email template" do
    assert Email.generate_template(@digest)
  end

  test "generate_email/2 creates a Swoosh.Email" do
    template = Email.generate_template(@digest)

    assert %Bamboo.Email{} = Email.generate_email(template, @user)
  end

  test "send_email/2 sends an email" do
    assert_delivered_email(Email.send_email(@user, @digest))
  end
end
