defmodule Bebemayotte.CommandesTest do
  use Bebemayotte.DataCase

  alias Bebemayotte.Commandes

  describe "commandes" do
    alias Bebemayotte.Commandes.Commande

    @valid_attrs %{date: ~D[2010-04-17], numero: "some numero", statut: true, total: 120.5}
    @update_attrs %{date: ~D[2011-05-18], numero: "some updated numero", statut: false, total: 456.7}
    @invalid_attrs %{date: nil, numero: nil, statut: nil, total: nil}

    def commande_fixture(attrs \\ %{}) do
      {:ok, commande} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commandes.create_commande()

      commande
    end

    test "list_commandes/0 returns all commandes" do
      commande = commande_fixture()
      assert Commandes.list_commandes() == [commande]
    end

    test "get_commande!/1 returns the commande with given id" do
      commande = commande_fixture()
      assert Commandes.get_commande!(commande.id) == commande
    end

    test "create_commande/1 with valid data creates a commande" do
      assert {:ok, %Commande{} = commande} = Commandes.create_commande(@valid_attrs)
      assert commande.date == ~D[2010-04-17]
      assert commande.numero == "some numero"
      assert commande.statut == true
      assert commande.total == 120.5
    end

    test "create_commande/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commandes.create_commande(@invalid_attrs)
    end

    test "update_commande/2 with valid data updates the commande" do
      commande = commande_fixture()
      assert {:ok, %Commande{} = commande} = Commandes.update_commande(commande, @update_attrs)
      assert commande.date == ~D[2011-05-18]
      assert commande.numero == "some updated numero"
      assert commande.statut == false
      assert commande.total == 456.7
    end

    test "update_commande/2 with invalid data returns error changeset" do
      commande = commande_fixture()
      assert {:error, %Ecto.Changeset{}} = Commandes.update_commande(commande, @invalid_attrs)
      assert commande == Commandes.get_commande!(commande.id)
    end

    test "delete_commande/1 deletes the commande" do
      commande = commande_fixture()
      assert {:ok, %Commande{}} = Commandes.delete_commande(commande)
      assert_raise Ecto.NoResultsError, fn -> Commandes.get_commande!(commande.id) end
    end

    test "change_commande/1 returns a commande changeset" do
      commande = commande_fixture()
      assert %Ecto.Changeset{} = Commandes.change_commande(commande)
    end
  end
end
