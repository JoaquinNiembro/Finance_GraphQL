defmodule Finance.Repo.Migrations.AddUserToBill do
  use Ecto.Migration

  def change do
    alter table(:bills) do
      add :user_id, references(:users)
    end
  end
end
