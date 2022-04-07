defmodule DemoJamdbOracleLimitOffset.Repo do
  use Ecto.Repo,
    otp_app: :demo_jamdb_oracle_limit_offset,
    adapter: Ecto.Adapters.Jamdb.Oracle
end
