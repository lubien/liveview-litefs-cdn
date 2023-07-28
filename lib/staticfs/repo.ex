defmodule Staticfs.Repo do
  use Ecto.Repo,
    otp_app: :staticfs,
    adapter: Ecto.Adapters.SQLite3
end
