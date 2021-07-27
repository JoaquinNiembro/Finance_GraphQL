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
    @desc "date of register"
    field :added_on, :date
    @desc "is completed"
    field :is_completed, :boolean do
      resolve(fn %{inserted_at: added_on}, _args, _context ->
        {:ok, !is_nil(added_on)}
      end)
    end
  end

  input_object :bill_filter do
    @desc "Matching a name"
    field :name, :string
    @desc "Priced above a value"
    field :priced_above, :float
    @desc "Priced below a value"
    field :priced_below, :float
    @desc "Added to the menu before this date"
    field :added_before, :date
    @desc "Added tot he menu after this date"
    field :added_after, :date
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  input_object :create_bill_input do
    field(:amount, non_null(:decimal))
    field(:name, non_null(:string))
  end

  input_object :update_bill_input do
    field(:id, non_null(:string))
    field(:amount, :decimal)
    field(:name, :string)
  end

  input_object :delete_bill do
    field :id, non_null(:string)
  end

  object :bill_queries do
    field :bills, list_of(:bill) do
      arg(:filter, non_null(:bill_filter))
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&BillsResolver.resolve_get_list_of_bills/3)
    end
  end

  object :delete_mutation_payload do
    field :bill, :bill
    field :msg, non_null(:string)
  end

  object :update_mutation_payload do
    field :bill, :bill
    field :msg, non_null(:string)
  end

  object :bills_mutations do
    field :create_bill, :bill do
      arg(:input, non_null(:create_bill_input))

      resolve(&BillsResolver.create_bill/3)
    end

    field :delete_bill, :delete_mutation_payload do
      arg(:input, non_null(:delete_bill))

      resolve(&BillsResolver.delete_bill/3)
    end

    field :update_bill, :update_mutation_payload do
      arg(:input, non_null(:update_bill_input))

      resolve(&BillsResolver.resolve_update_bill/3)
    end
  end
end
