defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: "/feeds")}
  end

  @impl true
  def render(assigns), do: ~L""
end
