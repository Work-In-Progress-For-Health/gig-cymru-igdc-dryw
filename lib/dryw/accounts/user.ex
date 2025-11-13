defmodule Dryw.Accounts.User do
  use Ash.Resource,
    otp_app: :dryw,
    domain: Dryw.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication]
  use Dryw.Accounts.User.Fab

  def snake_case_singular(), do: "user"
  def snake_case_plural(), do: "users"
  def title_case_singular(), do: "User"
  def title_case_plural(), do: "Users"

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end

    tokens do
      enabled? true
      token_resource Dryw.Accounts.Token
      signing_secret Dryw.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    strategies do
      magic_link do
        identity_field :email
        registration_enabled? true
        require_interaction? true

        sender Dryw.Accounts.User.Senders.SendMagicLinkEmail
      end
    end
  end

  postgres do
    table "users"
    repo Dryw.Repo
  end

  actions do
    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end

    read :get_by_email do
      description "Looks up a user by their email"
      argument :email, :ci_string do
        allow_nil? false
      end
      get_by :email
    end

    create :sign_in_with_magic_link do
      description "Sign in or register a user with magic link."

      argument :token, :string do
        description "The token from the magic link that was sent to the user"
        allow_nil? false
      end

      upsert? true
      upsert_identity :unique_email
      upsert_fields [:email]

      # Uses the information from the token to create or sign in the user
      change AshAuthentication.Strategy.MagicLink.SignInChange

      metadata :token, :string do
        allow_nil? false
      end
    end

    action :request_magic_link do
      argument :email, :ci_string do
        allow_nil? false
      end

      run AshAuthentication.Strategy.MagicLink.Request
    end

    defaults [:read, :destroy, :create, :update]

    default_accept [
      :email,
      :primary_manager_email_address,
      :secondary_managers_email_addresses,
      :direct_reports_email_addresses,
      :peers_email_addresses,
      :others_email_addresses
    ]

  end

  policies do

    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    # Allow anyone to create a new user account (public registration)
    policy action(:create) do
      description "Anyone can register a new account"
      authorize_if always()
    end

    # Protect read actions - users can read their own data
    policy action(:read) do
      authorize_if actor_present()
    end

    # Protect update/destroy actions - only the user can update/destroy their own data
    policy action([:update, :destroy]) do
      authorize_if actor_present()
      authorize_if relates_to_actor_via(:id)
    end

  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      public? true
      allow_nil? false
    end

    attribute :primary_manager_email_address, :string
    attribute :secondary_managers_email_addresses, :string
    attribute :direct_reports_email_addresses, :string
    attribute :peers_email_addresses, :string
    attribute :others_email_addresses, :string
  end

  identities do
    identity :unique_email, [:email]
  end

  def emails(user) do
    [
      user.primary_manager_email_address,
      user.secondary_managers_email_addresses,
      user.direct_reports_email_addresses,
      user.peers_email_addresses,
      user.others_email_addresses,
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
    |> String.split(~r/[,\s]+/)
  end

end
