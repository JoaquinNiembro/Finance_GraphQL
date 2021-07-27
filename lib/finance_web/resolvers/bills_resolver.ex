defmodule FinanceWeb.Resolvers.BillsResolver do
  alias Finance.Finances


  def resolve_get_list_of_bills(_object, args, _context) do
    {:ok, Finances.list_bills(args)}
  end

  def create_bill(_, %{input: params}, _) do
    case Finances.create_bill(params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, bill} ->
        {:ok, bill}
    end
  end

  def delete_bill(_, %{input: params}, _) do
    case Finances.delete_bill_mutation(params.id) do
      {:ok, bill} ->
        {:ok, %{bill: bill, msg: "bill deleted"}}

      {:error, msg} ->
        {:ok,
         %{
           bill: %{
             id: "null",
             amount: "null",
             added_on: ~D[2000-01-01],
             name: "null"
           },
           msg: msg
         }}
    end
  end

  def transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} -> %{key: key, message: value} end)
  end

  defp format_error({msg, opts}) do
    Enum.reduce(
      opts,
      msg,
      fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end
    )
  end
end
