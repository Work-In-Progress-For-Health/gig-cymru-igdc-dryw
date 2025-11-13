defmodule DrywWeb.GigCymru.Igdc.Pod360.Reviews.Test do
  import Phoenix.LiveViewTest
  use DrywWeb.ConnCase
  use DrywWeb.AuthCase
  alias Dryw.GigCymru.Igdc.Pod360.Review, as: X

  setup %{conn: conn} do
    user = my_user!()
    user = my_sign_in!(user)
    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> AshAuthentication.Plug.Helpers.store_in_session(user)

    {:ok, conn: conn, user: user}
  end

  test "new", %{conn: conn, user: user} do
    conn = get(conn, ~p"/gig-cymru/igdc/pod360/reviews/new/#{user.email}")
    response = html_response(conn, 200)

    assert response =~ "Collaboration"
    assert response =~ "Innovation"
    assert response =~ "Inclusive"
    assert response =~ "Excellence"
    assert response =~ "Compassion"

  end

  test "new…", %{conn: conn, user: user} do
    {:ok, lv, _html} = live(conn, ~p"/gig-cymru/igdc/pod360/reviews/new/#{user.email}")
    x = X.fab!
    result =
      lv
      |> form("#x_form", %{
        "form[collaboration]" => x.collaboration,
        "form[innovation]" => x.innovation,
        "form[inclusive]" => x.inclusive,
        "form[excellence]" => x.excellence,
        "form[compassion]" => x.compassion,
      })
      |> render_submit()
    case result do
      {:error, {:live_redirect, %{to: path}}} ->
        assert path == "/" #TODO
      html when is_binary(html) ->
        assert html =~ "header" #TODO
      other ->
        flunk("Unexpected result: #{inspect(other)}")
    end
  end
end
