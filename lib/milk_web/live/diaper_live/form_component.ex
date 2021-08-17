defmodule MilkWeb.DiaperLive.FormComponent do
  use MilkWeb, :live_component

  alias Milk.Diapers

  @impl true
  def update(%{diaper: diaper} = assigns, socket) do
    changeset = Diapers.change_diaper(diaper)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"diaper" => diaper_params}, socket) do
    changeset =
      socket.assigns.diaper
      |> Diapers.change_diaper(diaper_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"diaper" => diaper_params}, socket) do
    save_diaper(socket, socket.assigns.action, diaper_params)
  end

  defp save_diaper(socket, :new, diaper_params) do
    case Diapers.create_diaper(diaper_params) do
      {:ok, _diaper} ->
        {:noreply,
         socket
         |> put_flash(:info, "Diaper created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
