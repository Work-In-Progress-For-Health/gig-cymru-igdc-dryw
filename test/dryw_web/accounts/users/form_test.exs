defmodule DrywWeb.Users.Test do
  import Phoenix.LiveViewTest
  use DrywWeb.ConnCase
  use DrywWeb.AuthCase
  alias Dryw.Accounts.User, as: X

  setup %{conn: conn} do
    user = my_user!()
    user = my_sign_in!(user)
    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> AshAuthentication.Plug.Helpers.store_in_session(user)

    {:ok, conn: conn, user: user}
  end

  test "edit", %{conn: conn, user: user} do
    conn = get(conn, ~p"/users/#{user.id}/edit")
    response = html_response(conn, 200)

    assert response =~ "Your primary manager"
    assert response =~ "Your secondary managers"
    assert response =~ "Your direct reports"
    assert response =~ "Any peers"
    assert response =~ "Any others"

  end

  test "edit…", %{conn: conn, user: user} do
    {:ok, lv, _html} = live(conn, ~p"/users/#{user.id}/edit")
    x = X.fab!
    result =
      lv
      |> form("#x_form", %{
        "form[primary_manager_email_address]" => x.primary_manager_email_address,
        "form[secondary_managers_email_addresses]" => x.secondary_managers_email_addresses,
        "form[direct_reports_email_addresses]" => x.direct_reports_email_addresses,
        "form[peers_email_addresses]" => x.peers_email_addresses,
        "form[others_email_addresses]" => x.others_email_addresses,
      })
      |> render_submit()
    case result do
      {:error, {:live_redirect, %{to: path}}} ->
        assert path == ~p"/users/#{user.id}"
      html when is_binary(html) ->
        assert html =~ "Your primary manager" #TODO
      other ->
        flunk("Unexpected result: #{inspect(other)}")
    end
  end
end
