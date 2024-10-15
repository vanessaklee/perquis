defmodule Perquis.ExclusionsTest do
  use Perquis.DataCase

  alias Perquis.Exclusions

  describe "persons" do
    alias Perquis.Exclusions.Person

    import Perquis.ExclusionsFixtures

    @invalid_attrs %{first: nil, last: nil, state: nil, zip: nil, middle: nil, specialty: nil, dob: nil}

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Exclusions.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Exclusions.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{first: "some first", last: "some last", state: "some state", zip: "some zip", middle: "some middle", specialty: "some specialty", dob: "some dob"}

      assert {:ok, %Person{} = person} = Exclusions.create_person(valid_attrs)
      assert person.first == "some first"
      assert person.last == "some last"
      assert person.state == "some state"
      assert person.zip == "some zip"
      assert person.middle == "some middle"
      assert person.specialty == "some specialty"
      assert person.dob == "some dob"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exclusions.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{first: "some updated first", last: "some updated last", state: "some updated state", zip: "some updated zip", middle: "some updated middle", specialty: "some updated specialty", dob: "some updated dob"}

      assert {:ok, %Person{} = person} = Exclusions.update_person(person, update_attrs)
      assert person.first == "some updated first"
      assert person.last == "some updated last"
      assert person.state == "some updated state"
      assert person.zip == "some updated zip"
      assert person.middle == "some updated middle"
      assert person.specialty == "some updated specialty"
      assert person.dob == "some updated dob"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Exclusions.update_person(person, @invalid_attrs)
      assert person == Exclusions.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Exclusions.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Exclusions.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Exclusions.change_person(person)
    end
  end
end
