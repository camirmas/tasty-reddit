defmodule Email do
  import Bamboo.Email
  alias Email.Mailer

  def send_email(digest, email) do
    digest
    |> generate_template
    |> generate_email(email)
    |> Mailer.deliver_now
  end

  def generate_template(digest) do
    EEx.eval_file("#{__DIR__}/email/templates/digest.html.eex", digest: digest)
  end

  def generate_email(template, email) do
    new_email(
      to: email,
      from: "noreply@tastyreads.com",
      subject: "Your TastyReads Digest",
      html_body: template,
    )
  end
end
