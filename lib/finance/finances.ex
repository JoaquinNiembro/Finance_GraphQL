defmodule Finance.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Finance.Repo

  alias Finance.Finances.Bill

  @doc """
  Returns the list of bills.

  ## Examples

      iex> list_bills()
      [%Bill{}, ...]

  """
  def list_bills(args) do
    args
    |> Enum.reduce(
      Bill,
      fn
        {:order, order}, query ->
          query
          |> order_by({^order, :name})

        {:filter, filter}, query ->
          query
          |> filter_bills_by(filter)
      end
    )
    |> Repo.all()
  end

  defp filter_bills_by(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}")

      {:priced_above, price}, query ->
        from q in query, where: q.amount >= ^price

      {:priced_below, price}, query ->
        from q in query, where: q.amount <= ^price

      {:added_after, date}, query ->
        from q in query, where: q.added_on >= ^date

      {:added_before, date}, query ->
        from q in query, where: q.added_on <= ^date
    end)
  end

  @doc """
  Gets a single bill.

  Raises `Ecto.NoResultsError` if the Bill does not exist.

  ## Examples

      iex> get_bill!(123)
      %Bill{}

      iex> get_bill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bill!(id), do: Repo.get(Bill, id)

  @doc """
  Creates a bill.

  ## Examples

      iex> create_bill(%{field: value})
      {:ok, %Bill{}}

      iex> create_bill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bill(attrs \\ %{}) do
    %Bill{}
    |> Bill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bill.

  ## Examples

      iex> update_bill(bill, %{field: new_value})
      {:ok, %Bill{}}

      iex> update_bill(bill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bill(%Bill{} = bill, attrs) do
    bill
    |> Bill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bill.

  ## Examples

      iex> delete_bill(bill)
      {:ok, %Bill{}}

      iex> delete_bill(bill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bill(%Bill{} = bill) do
    Repo.delete(bill)
  end

  def delete_bill_mutation(id) do
    case get_bill!(String.to_integer(id)) do
      %Bill{} = bill ->
        delete_bill_for_mutation(bill)

      nil ->
        {:error, "No Bill found..."}
    end
  end

  defp delete_bill_for_mutation(%Bill{} = bill) do
    delete_bill(bill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bill changes.

  ## Examples

      iex> change_bill(bill)
      %Ecto.Changeset{data: %Bill{}}

  """
  def change_bill(%Bill{} = bill, attrs \\ %{}) do
    Bill.changeset(bill, attrs)
  end

  def update_mutation_handler(id, params) do
    case get_bill!(String.to_integer(id)) do
      %Bill{} = bill -> update_bill(bill, params)
      nil -> {:error, "No Bill found..."}
    end
  end
end
