defmodule Bebemayotte.EBPRepo do
  use Ecto.Repo,
    otp_app: :bebemayotte,
    adapter: Ecto.Adapters.Tds
end
