defmodule Finance.Accounts do
  import Ecto.Query, warn: false
  alias Finance.Repo
  alias Finance.Accounts.User
  alias Comeonin.Ecto.Password

  def authenticate(role, email, password) do
    IO.puts("que pedo")
    user = Repo.get_by(User, role: to_string(role), email: email)

    with %{password: digest} <- user, true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end
end
