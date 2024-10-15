defmodule Perquis.Exclusions do
  @moduledoc """
  The Exclusions context.
  """

  import Ecto.Query, warn: false
  alias Perquis.Repo

  alias Perquis.Exclusions.Person

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons do
    Repo.all(Person)
  end

  def list_persons(%{page: page, per_page: per_page} = opts) do
    paginate(from(p in Person), opts) |> Repo.all()
  end

  def list_persons(:and, %{last: last, first: first}) do
    from(p in Person,
      where: fragment("SIMILARITY(?, ?) > 0", p.first, ^first),
      where: fragment("SIMILARITY(?, ?) > 0", p.last, ^last),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.first, ^first),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.last, ^last)
    )
    |> Repo.all()
  end

  def list_persons(:or, %{last: last, first: first}) do
    from(
      p in Person,
      where:
        ilike(p.first, ^"#{first}%") or
          ilike(p.last, ^"#{last}%"),
      where:
        fragment("SIMILARITY(?, ?) > 0", p.first, ^first) or
          fragment("SIMILARITY(?, ?) > 0", p.last, ^last),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.last, ^last),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.first, ^first)
    )
    |> Repo.all()
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max(page - 1, 0) * per_page

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _), do: query

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
