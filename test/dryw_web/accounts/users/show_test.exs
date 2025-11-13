defmodule DrywWeb.Users.ShowTest do
  use DrywWeb.ConnCase
  use DrywWeb.AuthCase
  # alias Dryw.Accounts.User, as: X

  setup %{conn: conn} do
    user = my_user!()
    user = my_sign_in!(user)
    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> AshAuthentication.Plug.Helpers.store_in_session(user)

    {:ok, conn: conn, user: user}
  end

  test "show", %{conn: conn, user: user} do
    conn = get(conn, ~p"/users/#{user.id}")
    response = html_response(conn, 200)
    x = user

    assert response =~ "Primary manager: #{x.primary_manager_email_address}"
    assert response =~ "Secondary managers: #{x.secondary_managers_email_addresses}"
    assert response =~ "Direct reports: #{x.direct_reports_email_addresses}"
    assert response =~ "Peers: #{x.peers_email_addresses}"
    assert response =~ "Others: #{x.others_email_addresses}"

  end

end
