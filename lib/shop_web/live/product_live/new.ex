defmodule ShopWeb.ProductLive.New do
  use ShopWeb, :live_view

  alias Shop.Products
  alias Shop.Products.Product

  @impl true
  def mount(_params, _session, socket) do
    changeset = Products.change_product(%Product{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_navigate(to: ~p"/products-live")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto p-6 space-y-6">
      <h1 class="text-2xl font-bold text-black">New Product</h1>

    <.form for={@form} id="product_form" class="text-black" phx-submit="save">

      <.input field={@form[:name]} label="Name" required />
      <.input
      field={@form[:console]}
      type="select"
      label="Console"
      prompt="-- choose a console --"
      options={[
        {"Playstation", "playstation"},
        {"Nintendo", "nintendo"},
        {"Xbox", "xbox"},
        {"PC", "pc"}
      ]}
      />

      <.button class="btn btn-primary">Create</.button>
      <.link navigate={~p"/products-live"} class="btn btn-soft ml-2">Cancel</.link>
    </.form>
    </div>
    """
  end
end
