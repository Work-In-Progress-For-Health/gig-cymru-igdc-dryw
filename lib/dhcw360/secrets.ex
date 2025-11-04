defmodule DHCW360.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        DHCW360.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:dhcw360, :token_signing_secret)
  end
end
