defmodule Finance.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :amount, :decimal
      add :name, :string
      add :added_on, :date, null: false, default: fragment("NOW()")

      timestamps()
    end
  end
end
