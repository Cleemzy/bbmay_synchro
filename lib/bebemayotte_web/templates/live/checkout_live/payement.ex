defmodule BebemayotteWeb.Live.CheckoutLive.Payement do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.Customers.Customer
  alias Bebemayotte.Customers
  alias Bebemayotte.Checkouts
  alias Bebemayotte.Checkouts.Checkout
  alias Bebemayotte.Details
  alias Bebemayotte.Commandes

  @impl true
  def mount(_params, %{"id_session" => id_session, "num_commande" => num_commande}, socket) do
    commande = num_commande |> Commandes.get_commande_by_numero()
    amount = commande.total * 100
    categories = CatRequette.get_all_categorie()
    {
      :ok,
      socket
      |> assign(:changeset, Checkouts.change_checkout(%Checkout{}))
      |> assign(:checkout, nil)
      |> assign(:intent, nil)
      |> assign(:user, 1)
      |> assign(:amount, amount)
      |> assign(:search, nil)
      |> assign(:categories, categories),
      layout: {BebemayotteWeb.LayoutView, "payement_layout.html"}
    }
  end

  @impl true
  def handle_event("submit", %{"checkout" => checkout_params}, socket) do
    case Checkouts.create_checkout(checkout_params) do
      {:ok, checkout} ->
        IO.inspect checkout_params
        case Customers.find_double(checkout_params["name"], checkout_params["email"]) do
          nil ->
            {:ok, stripe_customer} = Stripe.Customer.create(%{email: checkout_params["email"], name: checkout_params["name"]})
            {:ok, customer} = Customers.create_customer(%{
              "name" => checkout_params["name"],
              "email" => checkout_params["email"],
              "stripe_customer_id" => stripe_customer.id
            })
            send(self(), {:create_payment_intent, checkout, customer}) # Run this async

            {:noreply, assign(socket, checkout: checkout, changeset: Checkouts.change_checkout(checkout))}
          id ->
            customer = id |> Customers.get_customer!()
            send(self(), {:create_payment_intent, checkout, customer}) # Run this async

            {:noreply, assign(socket, checkout: checkout, changeset: Checkouts.change_checkout(checkout))}
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect "checkout_params"
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("payment-success", %{"payment_method" => payment_method_id, "status" => status}, socket) do
    checkout = socket.assigns.checkout
    # Update the checkout with the result
    {:ok, checkout} = Checkouts.update_checkout(checkout, %{payment_method_id: payment_method_id, status: status})

    {:noreply, assign(socket, :checkout, checkout)}
  end

  @impl true
  def handle_info({:create_payment_intent, %{email: email, name: name, amount: amount, currency: currency} = checkout, customer}, socket) do
    IO.inspect customer
    with {:ok, payment_intent} <- Stripe.PaymentIntent.create(%{customer: customer.stripe_customer_id, amount: amount, currency: currency}) do
      # Update the checkout
      Checkouts.update_checkout(checkout, %{payment_intent_id: payment_intent.id})

      {:noreply, assign(socket, :intent, payment_intent)}
    else
      _ ->
        {:noreply, assign(socket, :stripe_error, "There was an error with the stripe")}
    end
  end

  def render(assigns) do
    BebemayotteWeb.CompteView.render("payement.html", assigns)
  end
end
