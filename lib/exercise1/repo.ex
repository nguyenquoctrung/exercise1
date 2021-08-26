defmodule Exercise1.Repo do
  use Ecto.Repo,
    otp_app: :exercise1,
    adapter: Ecto.Adapters.Postgres
end
