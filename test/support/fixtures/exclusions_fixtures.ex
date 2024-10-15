defmodule Perquis.ExclusionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Perquis.Exclusions` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        dob: "some dob",
        first: "some first",
        last: "some last",
        middle: "some middle",
        specialty: "some specialty",
        state: "some state",
        zip: "some zip"
      })
      |> Perquis.Exclusions.create_person()

    person
  end
end
