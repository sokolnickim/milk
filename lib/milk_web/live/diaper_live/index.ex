defmodule MilkWeb.DiaperLive.Index do
  use MilkWeb, :live_view

  alias Milk.Diapers
  alias Milk.Diapers.Diaper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, diapers: list_diapers(), opened_id: nil)}
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

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Editing Diapers")
  end

  @impl true
  def handle_event("open", %{"id" => id}, socket) do
    diaper = Diapers.get_diaper!(id)
    opened_id = if socket.assigns.opened_id != diaper.id, do: diaper.id
    {:noreply, assign(socket, :opened_id, opened_id)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    diaper = Diapers.get_diaper!(id)
    {:ok, _} = Diapers.delete_diaper(diaper)

    {:noreply, assign(socket, diapers: list_diapers())}
  end

  defp list_diapers do
    yesterday = NaiveDateTime.add(NaiveDateTime.local_now(), -24 * 3600)
    Diapers.list_diapers_since(yesterday)
  end
end
