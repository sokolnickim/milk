defmodule MilkWeb.WeightLive.FormComponent do
  use MilkWeb, :live_component

  alias Milk.Metrics
  import Milk.Metrics.Weight, only: [metric?: 1, imperial?: 1]

  @impl true
  def update(%{weight: weight} = assigns, socket) do
    changeset = Metrics.change_weight(weight)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"weight" => weight_params}, socket) do
    changeset =
      socket.assigns.weight
      |> Metrics.change_weight(weight_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"weight" => weight_params}, socket) do
    save_weight(socket, socket.assigns.action, weight_params)
  end

  defp save_weight(socket, :new, weight_params) do
    case Metrics.create_weight(weight_params) do
      {:ok, _weight} ->
        {:noreply,
         socket
         |> put_flash(:info, "Weight created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
