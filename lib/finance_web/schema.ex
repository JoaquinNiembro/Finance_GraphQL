defmodule FinanceWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.{BillTypes})

  scalar :decimal do
    parse(fn
      %{value: value}, _ ->
        IO.inspect(value)
        Decimal.from_float(value)

      _, _ ->
        :error
    end)

    serialize(&to_string/1)
  end

  query do
    import_fields(:bill_queries)
  end

  mutation do
    field :create_bill, :bill do
      arg(:input, non_null(:create_bill_input))

      resolve(&FinanceWeb.Resolvers.BillsResolver.create_bill/3)
    end
  end
end
