defmodule Finance.Seeds do
  alias Finance.{Repo, Finances.Bill}

  def run_bills do
    Repo.insert!(%Bill{
      amount: 3200.00,
      name: "Teclado Keychron K2"
    })

    Repo.insert!(%Bill{
      amount: 5000.00,
      name: "Beats Studio 3"
    })

    Repo.insert!(%Bill{
      amount: 200.00,
      name: "Six de Stella Artois"
    })
  end
end
