defmodule PerquisWeb.PersonLiveTest do
  use PerquisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Perquis.ExclusionsFixtures

  @create_attrs %{first: "some first", last: "some last", state: "some state", zip: "some zip", middle: "some middle", specialty: "some specialty", dob: "some dob"}
  @update_attrs %{first: "some updated first", last: "some updated last", state: "some updated state", zip: "some updated zip", middle: "some updated middle", specialty: "some updated specialty", dob: "some updated dob"}
  @invalid_attrs %{first: nil, last: nil, state: nil, zip: nil, middle: nil, specialty: nil, dob: nil}

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all persons", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/persons")

      assert html =~ "Listing Persons"
      assert html =~ person.first
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert index_live |> element("a", "New Person") |> render_click() =~
               "New Person"

      assert_patch(index_live, ~p"/persons/new")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/persons")

      html = render(index_live)
      assert html =~ "Person created successfully"
      assert html =~ "some first"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert index_live |> element("#persons-#{person.id} a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(index_live, ~p"/persons/#{person}/edit")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/persons")

      html = render(index_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert index_live |> element("#persons-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#persons-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/persons/#{person}")

      assert html =~ "Show Person"
      assert html =~ person.first
    end

    test "updates person within modal", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/persons/#{person}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(show_live, ~p"/persons/#{person}/show/edit")

      assert show_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/persons/#{person}")

      html = render(show_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first"
    end
  end
end
