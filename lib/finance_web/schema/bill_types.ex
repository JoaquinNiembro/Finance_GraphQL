defmodule FinanceWeb.Schema.BillTypes do
  use Absinthe.Schema.Notation
  alias FinanceWeb.Resolvers.BillsResolver

  object :bill do
    @desc "Bill identifier"
    field :id, non_null(:id)
    @desc "Amount of money spent"
    field :amount, non_null(:decimal)
    @desc "Name of the things buyed"
    field :name, non_null(:string)
    @desc "is completed"
    field :is_completed, :boolean do
      resolve(fn %{inserted_at: added_on}, _args, _context ->
        {:ok, !is_nil(added_on)}
      end)
    end
  end

  input_object :create_bill_input do
    field(:amount, non_null(:decimal))
    field(:name, non_null(:string))
  end

  object :bill_queries do
    field :bills, list_of(:bill) do
      resolve(&BillsResolver.resolve_get_list_of_bills/3)
    end
  end
end
