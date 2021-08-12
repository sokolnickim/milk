defmodule MilkWeb.BottleLive.Index do
  use MilkWeb, :live_view

  alias Milk.Bottles
  alias Milk.Bottles.Bottle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :bottles, list_bottles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bottle")
    |> assign(:bottle, Bottles.get_bottle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bottle")
    |> assign(:bottle, %Bottle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bottles")
    |> assign(:bottle, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bottle = Bottles.get_bottle!(id)
    {:ok, _} = Bottles.delete_bottle(bottle)

    {:noreply, assign(socket, :bottles, list_bottles())}
  end

  def handle_event("fill", %{"id" => id}, socket) do
    bottle = Bottles.get_bottle!(id)
    {:ok, _} = Bottles.fill_bottle(bottle)

    {:noreply, assign(socket, :bottles, list_bottles())}
  end

  defp list_bottles do
    Bottles.list_bottles()
  end
end
