defmodule PerquisWeb.PersonLive.Index do
  alias PerquisWeb.PersonLive
  use PerquisWeb, :live_view

  alias Perquis.Exclusions
  alias Perquis.Exclusions.Person

  on_mount {PerquisWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        options: %{
          page: 1,
          per_page: 10
        }
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = (params["page"] || socket.assigns.options.page) |> String.to_integer()
    per_page = (params["per_page"] || socket.assigns.options.per_page) |> String.to_integer()

    socket =
      assign(socket,
        persons: Perquis.Exclusions.list_persons(%{page: page, per_page: per_page}),
        first: params["first"],
        last: params["last"],
        conj: "or",
        options: %{
          sort_by: :last,
          sort_order: :asc,
          page: page,
          per_page: per_page
        }
      )

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Exclusions.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Persons")
    |> assign(:person, nil)
  end

  def handle_event("search", %{"first" => first, "last" => last, "conj" => conj}, socket) do
    persons =
      Exclusions.list_persons(String.to_atom(conj), %{
        first: first,
        last: last
      })

    socket =
      assign(socket,
        first: first,
        last: last,
        conj: conj,
        persons: persons
      )

    {:noreply, socket}
  end

  def handle_event("sort-by", %{"sort-column" => sort_by}, socket) do
    new_sort_by = sort_by |> String.downcase() |> String.to_atom()
    sort_by = socket.assigns.options.sort_by
    sort_order = socket.assigns.options.sort_order

    new_sort_order =
      case {sort_by, new_sort_by, sort_order} do
        {b, n, :asc} when b == n -> :desc
        _ -> :asc
      end

    options = %{
      sort_order: new_sort_order,
      sort_by: new_sort_by
    }

    persons =
      socket.assigns.persons
      |> Enum.sort_by(&Map.get(&1, new_sort_by), new_sort_order)

    socket =
      assign(socket,
        options: options,
        persons: persons,
        reset: true
      )

    {:noreply, socket}
  end
end
