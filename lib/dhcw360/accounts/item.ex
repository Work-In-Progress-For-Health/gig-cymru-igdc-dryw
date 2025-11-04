defmodule DHCW360.Accounts.Item do
  use Ash.Resource, otp_app: :dhcw360, domain: DHCW360.Accounts, data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo DHCW360.Repo
  end

  actions do
    defaults [:read, :destroy, create: [], update: []]
  end

  attributes do
    uuid_primary_key :id
  end

  relationships do
    belongs_to :reviewer, DHCW360.Accounts.User
    belongs_to :reviewee, DHCW360.Accounts.User
  end
end
