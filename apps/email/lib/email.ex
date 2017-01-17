defmodule Email do
  import Bamboo.Email
  alias Email.Mailer

  def send_email(user, digest) do
    digest
    |> generate_template
    |> generate_email(user)
    |> Mailer.deliver_now
  end

  def generate_template(digest) do
    EEx.eval_file("#{__DIR__}/email/templates/digest.html.eex", digest: digest)
  end

  def generate_email(template, user) do
    new_email(
      to: user.email,
      from: "noreply@tastyreads.com",
      subject: "Your TastyReads Digest",
      html_body: template,
    )
  end
end
