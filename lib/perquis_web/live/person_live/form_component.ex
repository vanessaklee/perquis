defmodule PerquisWeb.PersonLive.FormComponent do
  use PerquisWeb, :live_component

  alias Perquis.Exclusions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:last]} type="text" label="Last" />
        <.input field={@form[:first]} type="text" label="First" />
        <.input field={@form[:middle]} type="text" label="Middle" />
        <.input field={@form[:specialty]} type="text" label="Specialty" />
        <.input field={@form[:dob]} type="text" label="Dob" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:zip]} type="text" label="Zip" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Exclusions.change_person(person))
     end)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = Exclusions.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Exclusions.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Exclusions.create_person(person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
