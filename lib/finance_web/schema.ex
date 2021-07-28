defmodule FinanceWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.{BillTypes})

  scalar :decimal do
    parse(fn
      %{value: value}, _ ->
        {:ok, is_decimal_type(value)}

      _, _ ->
        :error
    end)

    serialize(&to_string/1)
  end

  scalar :date do
    parse(fn input ->
      case Date.from_iso8601(input.value) do
        {:ok, date} -> {:ok, date}
        _ -> :error
      end
    end)

    serialize(fn date -> Date.to_iso8601(date) end)
  end

  defp is_decimal_type(value) do
    case is_integer(value) do
      true -> value
      false -> Decimal.from_float(value)
    end
  end

  query do
    import_fields(:bill_queries)
  end

  mutation do
    import_fields(:bills_mutations)
  end

  subscription do
    import_fields(:bills_subscriptions)
  end
end
