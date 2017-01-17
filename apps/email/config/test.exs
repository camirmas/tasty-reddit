use Mix.Config

config :email, Email.Mailer,
  adapter: Bamboo.TestAdapter
