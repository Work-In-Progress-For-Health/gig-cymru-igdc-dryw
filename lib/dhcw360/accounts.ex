defmodule DHCW360.Accounts do
  use Ash.Domain,
    otp_app: :dhcw360

  resources do
    resource DHCW360.Accounts.Token
    resource DHCW360.Accounts.User
  end
end
