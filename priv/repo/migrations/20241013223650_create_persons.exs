defmodule Perquis.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :last, :string
      add :first, :string
      add :middle, :string
      add :specialty, :string
      add :dob, :string
      add :state, :string
      add :zip, :string

      timestamps(type: :utc_datetime)
    end
  end
end
