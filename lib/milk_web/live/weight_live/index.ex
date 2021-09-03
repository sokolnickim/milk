defmodule MilkWeb.WeightLive.Index do
  use MilkWeb, :live_view

  alias Milk.Metrics
  alias Milk.Metrics.Weight

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, weights: list_weights(), units: :metric)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()

    socket
    |> assign(:page_title, "New Weight")
    |> assign(:weight, %Weight{date: today})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Weights")
    |> assign(:weight, nil)
  end

  @impl true
  def handle_event("to_metric", %{}, socket) do
    {:noreply, assign(socket, :units, :metric)}
  end

  def handle_event("to_imperial", %{}, socket) do
    {:noreply, assign(socket, :units, :imperial)}
  end

  defp list_weights do
    Metrics.list_weights()
  end
end
