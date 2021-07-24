defmodule Finance.FinancesTest do
  use Finance.DataCase

  alias Finance.Finances

  describe "bills" do
    alias Finance.Finances.Bill

    @valid_attrs %{amount: "120.5", name: "some name"}
    @update_attrs %{amount: "456.7", name: "some updated name"}
    @invalid_attrs %{amount: nil, name: nil}

    def bill_fixture(attrs \\ %{}) do
      {:ok, bill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finances.create_bill()

      bill
    end

    test "list_bills/0 returns all bills" do
      bill = bill_fixture()
      assert Finances.list_bills() == [bill]
    end

    test "get_bill!/1 returns the bill with given id" do
      bill = bill_fixture()
      assert Finances.get_bill!(bill.id) == bill
    end

    test "create_bill/1 with valid data creates a bill" do
      assert {:ok, %Bill{} = bill} = Finances.create_bill(@valid_attrs)
      assert bill.amount == Decimal.new("120.5")
      assert bill.name == "some name"
    end

    test "create_bill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finances.create_bill(@invalid_attrs)
    end

    test "update_bill/2 with valid data updates the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{} = bill} = Finances.update_bill(bill, @update_attrs)
      assert bill.amount == Decimal.new("456.7")
      assert bill.name == "some updated name"
    end

    test "update_bill/2 with invalid data returns error changeset" do
      bill = bill_fixture()
      assert {:error, %Ecto.Changeset{}} = Finances.update_bill(bill, @invalid_attrs)
      assert bill == Finances.get_bill!(bill.id)
    end

    test "delete_bill/1 deletes the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{}} = Finances.delete_bill(bill)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_bill!(bill.id) end
    end

    test "change_bill/1 returns a bill changeset" do
      bill = bill_fixture()
      assert %Ecto.Changeset{} = Finances.change_bill(bill)
    end
  end
end
