defmodule Bebemayotte.DetailTest do
  use Bebemayotte.DataCase

  alias Bebemayotte.Detail

  describe "detailcommandes" do
    alias Bebemayotte.Detail.Detailcommandes

    @valid_attrs %{id_commande: 42, id_produit: "some id_produit", numero: "some numero", quantite: 42}
    @update_attrs %{id_commande: 43, id_produit: "some updated id_produit", numero: "some updated numero", quantite: 43}
    @invalid_attrs %{id_commande: nil, id_produit: nil, numero: nil, quantite: nil}

    def detailcommandes_fixture(attrs \\ %{}) do
      {:ok, detailcommandes} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Detail.create_detailcommandes()

      detailcommandes
    end

    test "list_detailcommandes/0 returns all detailcommandes" do
      detailcommandes = detailcommandes_fixture()
      assert Detail.list_detailcommandes() == [detailcommandes]
    end

    test "get_detailcommandes!/1 returns the detailcommandes with given id" do
      detailcommandes = detailcommandes_fixture()
      assert Detail.get_detailcommandes!(detailcommandes.id) == detailcommandes
    end

    test "create_detailcommandes/1 with valid data creates a detailcommandes" do
      assert {:ok, %Detailcommandes{} = detailcommandes} = Detail.create_detailcommandes(@valid_attrs)
      assert detailcommandes.id_commande == 42
      assert detailcommandes.id_produit == "some id_produit"
      assert detailcommandes.numero == "some numero"
      assert detailcommandes.quantite == 42
    end

    test "create_detailcommandes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Detail.create_detailcommandes(@invalid_attrs)
    end

    test "update_detailcommandes/2 with valid data updates the detailcommandes" do
      detailcommandes = detailcommandes_fixture()
      assert {:ok, %Detailcommandes{} = detailcommandes} = Detail.update_detailcommandes(detailcommandes, @update_attrs)
      assert detailcommandes.id_commande == 43
      assert detailcommandes.id_produit == "some updated id_produit"
      assert detailcommandes.numero == "some updated numero"
      assert detailcommandes.quantite == 43
    end

    test "update_detailcommandes/2 with invalid data returns error changeset" do
      detailcommandes = detailcommandes_fixture()
      assert {:error, %Ecto.Changeset{}} = Detail.update_detailcommandes(detailcommandes, @invalid_attrs)
      assert detailcommandes == Detail.get_detailcommandes!(detailcommandes.id)
    end

    test "delete_detailcommandes/1 deletes the detailcommandes" do
      detailcommandes = detailcommandes_fixture()
      assert {:ok, %Detailcommandes{}} = Detail.delete_detailcommandes(detailcommandes)
      assert_raise Ecto.NoResultsError, fn -> Detail.get_detailcommandes!(detailcommandes.id) end
    end

    test "change_detailcommandes/1 returns a detailcommandes changeset" do
      detailcommandes = detailcommandes_fixture()
      assert %Ecto.Changeset{} = Detail.change_detailcommandes(detailcommandes)
    end
  end
end
