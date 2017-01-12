defmodule Email do
  def send_email(user, digest) do
    digest
    |> generate_template
    |> deliver(user)
  end

  def generate_template(digest) do
    EEx.eval_file("lib/email/templates/digest.html.eex", digest: digest)
  end

  def deliver(_template, _user) do
  end
end
