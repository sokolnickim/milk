defmodule MilkWeb.BottleLive.FormComponent do
  use MilkWeb, :live_component

  alias Milk.Bottles

  @impl true
  def update(%{bottle: bottle} = assigns, socket) do
    changeset = Bottles.change_bottle(bottle)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bottle" => bottle_params}, socket) do
    changeset =
      socket.assigns.bottle
      |> Bottles.change_bottle(bottle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bottle" => bottle_params}, socket) do
    save_bottle(socket, socket.assigns.action, bottle_params)
  end

  defp save_bottle(socket, :new, bottle_params) do
    case Bottles.create_bottle(bottle_params) do
      {:ok, _bottle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bottle created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
