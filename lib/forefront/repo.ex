defmodule Forefront.Repo do
  use Ecto.Repo,
    otp_app: :forefront,
    adapter: Ecto.Adapters.Postgres
end
