defmodule MilkWeb.BottleLive.Index do
  use MilkWeb, :live_view

  alias Milk.Bottles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, bottles: list_bottles(), changeset: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, page_title: "Listing Bottles", changeset: nil)
  end

  defp apply_action(socket, :edit, _params) do
    changeset = Bottles.change_bottle(%Bottles.Bottle{})
    assign(socket, page_title: "Editing Bottles", changeset: changeset)
  end

  @impl true
  def handle_event("validate", %{"bottle" => bottle_params}, socket) do
    changeset =
      %Bottles.Bottle{}
      |> Bottles.change_bottle(bottle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("add", %{"bottle" => bottle_params}, socket) do
    socket =
      case Bottles.create_bottle(bottle_params) do
        {:ok, _bottle} ->
          socket
          |> put_flash(:info, "Bottle created successfully")
          |> assign(bottles: list_bottles())
          |> assign(changeset: Bottles.change_bottle(%Bottles.Bottle{}))

        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> put_flash(:error, "Invalid bottle parameters")
          |> assign(changeset: changeset)
      end

    {:noreply, socket}
  end

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

  def handle_event("empty", %{"id" => id}, socket) do
    bottle = Bottles.get_bottle!(id)
    {:ok, _} = Bottles.empty_bottle(bottle)

    {:noreply, assign(socket, :bottles, list_bottles())}
  end

  defp list_bottles do
    Bottles.list_bottles()
  end

  defp classes_for_bottle(bottle) do
    cond do
      Bottles.is_empty(bottle) -> ""
      Bottles.is_expired(bottle) -> "text-danger"
      true -> "text-success"
    end
  end
end
