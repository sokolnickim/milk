defmodule MilkWeb.DiaperLive.Index do
  use MilkWeb, :live_view

  alias Milk.Diapers
  alias Milk.Diapers.Diaper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :diapers, list_diapers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Diaper")
    |> assign(:diaper, %Diaper{disposed_at: NaiveDateTime.local_now()})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Diapers")
    |> assign(:diaper, nil)
  end

  defp list_diapers do
    Diapers.list_diapers()
  end
end
