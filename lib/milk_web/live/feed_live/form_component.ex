defmodule MilkWeb.FeedLive.FormComponent do
  use MilkWeb, :live_component

  alias Milk.Feeds

  @impl true
  def update(%{feed: feed} = assigns, socket) do
    changeset = Feeds.change_feed(feed)

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"feed" => feed_params}, socket) do
    changeset =
      socket.assigns.feed
      |> Feeds.change_feed(feed_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"feed" => feed_params}, socket) do
    case Feeds.create_feed(feed_params) do
      {:ok, _feed} ->
        {:noreply, push_redirect(socket, to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
