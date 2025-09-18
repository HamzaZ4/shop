defmodule ShopWeb.ProductHTML do
  use ShopWeb, :html
  alias Shop.Products.Product

  embed_templates("product_html/*")

  # these values are required in all pages??
  # this function essentiallydeclares that myu component ( product )
  # accepts an attribute called name
  # and that it is required
  # <.product name={@product.name}/>

  # this only applies to the component defined right after this declaraition
  attr(:product, Product, required: true)

  def product(assigns) do
    ~H"""
    <a href={"/products/#{@product.slug}"} > Game: <%=@product.name%></a>
    <br>
    """
  end
end
