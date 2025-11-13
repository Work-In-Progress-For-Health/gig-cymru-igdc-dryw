defmodule DrywWeb.GigCymru.Igdc.Pod360.Requests.ShowLive do
  use DrywWeb, :live_view
  alias DrywWeb.Layouts

  require Logger

  @doc """
  Mount the LiveView:
  - Update a resource via an item id.
  - Create a new resource.
  """

  def mount(%{"reviewee_email" => reviewee_email}, _session, socket) do
    actor = socket.assigns.current_user
    reviewee =  Ash.get!(Dryw.Accounts.User, [email: reviewee_email], domain: Dryw.Accounts, actor: actor)

    {:ok,
     assign(socket,
       page_title: "DHCW Values-Based 360-Feedback: Request by #{reviewee.email}",
       reviewee: reviewee
     )}
  end

  @doc """
  Render.
  """
  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
      </.header>

      <p>From: {@reviewee.email}</p>

      <p>To: {Dryw.Accounts.User.emails(@reviewee) |> Enum.join(", ")}</p>

      <p>As part of my continual personal development I am about to take part in the DHCW Values-based 360-degree feedback process, and am writing to ask you whether you would be willing to complete a questionnaire on my behalf.</p>

      <p>The 360-degree feedback technique is a process through which information is gathered about me and my behaviour at work from the people I work closely with. I shall be asking a number of people to rate me including my manager, colleagues, and direct reports.</p>

      <p>The information you provide will be confidential and, owing to the requirement to have 3 or more raters in each values category, your individual responses will remain anonymous to me. (TODO: this isn't true - needs fixing)</p>

      <p>Please note however, if you are completing feedback as my line manager, your responses will not be anonymous.</p>

      <p>The questionnaire, based on the HCW Values and Behaviour Framework, will ask you to consider my leadership behaviour at work. When completing the questionnaire, please consider the content in which I operate.</p>

      <p>Your feedback and comments are of great value to me and will help me to identify my self-development goals and strategies.</p>

      <p>Please review me at this link:</p>

      <p>https://example.com/gig-cymru/igdc/pod360/reviews/new/{@reviewee.email}</p>

      <p>Kind regards.</p>

    </Layouts.app>
    """
  end


end
