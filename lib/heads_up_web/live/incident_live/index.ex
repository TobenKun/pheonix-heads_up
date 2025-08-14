defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _sessions, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(page_title: "Incidents")
      |> assign(form: to_form(params))
      |> stream(:incidents, Incidents.filter_incidents(params))

    socket =
      attach_hook(socket, :log_stream, :after_render, fn
        socket ->
          IO.inspect(socket.assigns.streams.incidents, label: "AFTER RENDER")
          socket
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </.headline>

      <.filter_form form={@form} />

      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No incidents found. Try changing your filters.
        </div>
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="300" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :canceled, :resolved]}
      />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort by"
        options={[
          Name: "name",
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc"
        ]}
      />
      <.link navigate={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~W(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_navigate(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end

"""
# make the filter criteria shareable and bookmarkable!

#### 해야할 것
- filter handle event에서 params 정리하기
  -> q, status, sort_by 필드만 가져오고 비어있는 필드는 맵에서 삭제

- push_navigate 함수로 url을 바꿔서 새로 마운트 하기
  -> 인자로는 정리된 params 전달

- handle_param 콜백 선언하고 마운트에 있는 동작 handle_param콜백으로 인자로는

- url에 있는 값을 받아오는 params 맵을 to_form함수에 전달해서 :form에 assign 하기
"""
