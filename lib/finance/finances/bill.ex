defmodule Finance.Finances.Bill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bills" do
    field :amount, :decimal
    field :name, :string
    field :added_on, :date

    timestamps()
  end

  @doc false
  def changeset(bill, attrs) do
    bill
    |> cast(attrs, [:amount, :name])
    |> validate_required([:amount, :name])
  end
end
