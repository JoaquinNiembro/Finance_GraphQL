defmodule FinanceWeb.Schema do
  use Absinthe.Schema
  alias FinanceWeb.Schema.Middleware

  import_types(FinanceWeb.Schema.Types.{BillTypes, AuthTypes})

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
    import_fields(:auth_mutations)
  end

  subscription do
    import_fields(:bills_subscriptions)
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
      when identifier in [:mutation] do
    [Middleware.ChangesetErrors | middleware]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
