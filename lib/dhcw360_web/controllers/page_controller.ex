defmodule DHCW360Web.PageController do
  use DHCW360Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
