defmodule Finance.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :amount, :decimal
      add :name, :string

      timestamps()
    end
  end
end
