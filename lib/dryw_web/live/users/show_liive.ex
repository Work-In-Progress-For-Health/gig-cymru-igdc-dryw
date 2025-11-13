defmodule DrywWeb.Users.ShowLive do
  use DrywWeb, :live_view
  alias Dryw.Accounts.User, as: X

  require Logger

  @doc """
  Mount.
  """
  def mount(%{"id" => id}, _session, socket) do
    actor = socket.assigns.current_user
    x = Ash.get!(X, id, domain: Dryw.Accounts, actor: actor)

    {:ok,
     assign(socket,
       page_title: "Show #{x.email}",
       x: x
     )}
  end

  @doc """
  Render.
  """
  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@current_user.email}
      </.header>

      <ul>
        <li>Primary manager: {@x.primary_manager_email_address}</li>
        <li>Secondary managers: {@x.secondary_managers_email_addresses}</li>
        <li>Direct reports: {@x.direct_reports_email_addresses}</li>
        <li>Peers: {@x.peers_email_addresses}</li>
        <li>Others: {@x.others_email_addresses}</li>
      </ul>

      <p>You can now email these people as you wish, such as using this template…</p>

      <p>From: {@x.email}</p>

      <p>To: {Dryw.Accounts.User.emails(@x)}</p>

      <p>Please review me at this link:</p>

      <p>https://example.com/gig-cymru/igdc/pod360/reviews/new/{@x.email}</p>

    </Layouts.app>
    """
  end

end
