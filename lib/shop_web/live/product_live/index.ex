defmodule ShopWeb.ProductLive.Index do
  use ShopWeb, :live_view

  alias Shop.Products

  def mount(_params, _session, socket) do
    products = Products.list_products()

    likes =
      products
      |> Enum.map(fn prod -> {prod.id, 0} end)
      |> Map.new()

    socket =
      socket
      |> assign(:products, products)
      |> assign(:likes, likes)

    {:ok, socket}
  end

  def handle_event("like", %{"id" => id}, socket) do
    id = String.to_integer(id)

    likes = Map.put(socket.assigns.likes, id, socket.assigns.likes[id] + 1)

    socket = socket |> assign(:likes, likes)

    {:noreply, socket}
  end

  def handle_event("dislike", %{"id" => id}, socket) do
    id = String.to_integer(id)

    likes = Map.put(socket.assigns.likes, id, socket.assigns.likes[id] - 1)

    socket = socket |> assign(:likes, likes)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-2xl font-bold mb-6 text-white">
        Product Likes
      </h1>

      <div class="space-y-4">
        <div
          :for={product <- @products}
          class="flex items-center justify-between p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow"
        >
          <div>
            <p class="text-lg font-semibold text-gray-900">
              <%= product.name %>
            </p>
            <p class="text-sm text-gray-500">
              Likes: <%= @likes[product.id] %>
            </p>
          </div>

          <div class="flex items-center space-x-3">
            <.icon
              name="hero-hand-thumb-down-mini"
              class="w-6 h-6 text-red-500 hover:text-red-600 cursor-pointer transition-colors"
              phx-click="dislike"
              phx-value-id={product.id}
            />
            <.icon
              name="hero-hand-thumb-up-mini"
              class="w-6 h-6 text-green-500 hover:text-green-600 cursor-pointer transition-colors"
              phx-click="like"
              phx-value-id={product.id}
            />
          </div>
        </div>

        <div
          class="flex items-center justify-between p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow"
        >
        <div>
            <.link navigate = {~p"/products-live/new"} class = "text-lg font-semibold text-gray-900">
            Add Product
            </.link>
          </div>
        </div>

      </div>


    </div>
    """
  end
end
