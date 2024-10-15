defmodule Perquis.Repo do
  use Ecto.Repo,
    otp_app: :perquis,
    adapter: Ecto.Adapters.Postgres
end
