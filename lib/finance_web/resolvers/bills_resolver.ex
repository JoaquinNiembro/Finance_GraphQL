defmodule FinanceWeb.Resolvers.BillsResolver do
  alias Finance.Finances

  def resolve_get_list_of_bills(_object, args, _context) do
    {:ok, Finances.list_bills(args)}
  end

  def create_bill(_, %{input: params}, %{context: context}) do
    case context do
      %{current_user: %{role: "employee"}} ->
        with {:ok, bill} <- Finances.create_bill(params) do
          Absinthe.Subscription.publish(
            FinanceWeb.Endpoint,
            bill,
            new_bill: "*"
          )

          {:ok, bill}
        end

      _ ->
        {:error, "unauthorized"}
    end
  end

  def delete_bill(_, %{input: params}, _) do
    case Finances.delete_bill_mutation(params.id) do
      {:ok, bill} ->
        Absinthe.Subscription.publish(
          FinanceWeb.Endpoint,
          bill,
          delete_bill: "*"
        )

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

  def resolve_update_bill(_, %{input: params}, _) do
    case Finances.update_mutation_handler(params.id, params) do
      {:ok, bill} ->
        {:ok, %{bill: bill, msg: "bill updated"}}

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
end
