defmodule Perquis.Exclusions.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :first, :string
    field :last, :string
    field :state, :string
    field :zip, :string
    field :middle, :string
    field :specialty, :string
    field :dob, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:last, :first, :middle, :specialty, :dob, :state, :zip])
    |> validate_required([:last, :first, :middle, :specialty, :dob, :state, :zip])
  end
end
