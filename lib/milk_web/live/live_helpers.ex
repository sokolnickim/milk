defmodule MilkWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MilkWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal MilkWeb.BottleLive.FormComponent,
        id: @bottle.id || :new,
        action: @live_action,
        bottle: @bottle,
        return_to: Routes.bottle_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    title = Keyword.fetch!(opts, :title)
    modal_opts = [id: :modal, title: title, return_to: path, component: component, opts: opts]
    live_component(MilkWeb.ModalComponent, modal_opts)
  end
end
