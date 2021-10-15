defmodule Bebemayotte.Repo do
  use Ecto.Repo,
    otp_app: :bebemayotte,
    adapter: Ecto.Adapters.Postgres
end
