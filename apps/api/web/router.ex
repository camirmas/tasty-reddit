defmodule Api.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Api do
    pipe_through :api

    scope "/v1" do
      post "/register", RegistrationController, :create
      delete "/unsubscribe", RegistrationController, :delete
    end
  end
end
