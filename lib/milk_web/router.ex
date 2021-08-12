defmodule MilkWeb.Router do
  use MilkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MilkWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MilkWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/bottles", BottleLive.Index, :index
    live "/bottles/new", BottleLive.Index, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", MilkWeb do
  #   pipe_through :api
  # end
end
