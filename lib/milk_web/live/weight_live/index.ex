defmodule MilkWeb.WeightLive.Index do
  use MilkWeb, :live_view

  alias Milk.Metrics
  alias Milk.Metrics.Weight

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :weights, list_weights())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Weight")
    |> assign(:weight, %Weight{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Weights")
    |> assign(:weight, nil)
  end

  defp list_weights do
    Metrics.list_weights()
  end
end
