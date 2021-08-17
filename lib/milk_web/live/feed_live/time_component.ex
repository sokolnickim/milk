defmodule MilkWeb.FeedLive.TimeComponent do
  use MilkWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{last_feed: last_feed}, socket) do
    socket =
      if is_nil(last_feed) do
        assign(socket, :end_time, nil)
      else
        assign(socket,
          change_time: NaiveDateTime.add(last_feed.started_at, 15 * 60),
          end_time: NaiveDateTime.add(last_feed.started_at, 30 * 60)
        )
      end

    socket = assign(socket, :current_time, NaiveDateTime.local_now())
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <ul class="list-group pb-3">
      <li class="list-group-item">
        <span>Current time is</span>
        <span class="fw-bold"><%= print_12h_time(@current_time) %></span>
      </li>
      <%= if @end_time && NaiveDateTime.diff(@current_time, @end_time) < 3600 do %>
      <li class="list-group-item">
        <span>Change side at</span>
        <span class="fw-bold"><%= print_12h_time(@change_time) %></span>
      </li>
      <li class="list-group-item">
        <span>End feed at</span>
        <span class="fw-bold"><%= print_12h_time(@end_time) %></span>
      </li>
      <% end %>
    </ul>
    """
  end
end
