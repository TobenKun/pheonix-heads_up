defmodule HeadsUpWeb.AdminIncidentLive.Index do
  import HeadsUpWeb.CustomComponents
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        {@page_title}
        <.table id="incidents" rows={@streams.incidents}>
          <:col :let={{_dom_id, incident}} label="Name">
            <.link navigate={~p"/incidents/#{incident}"}>
              {incident.name}
            </.link>
          </:col>
          <:col :let={{_dom_id, incident}} label="Status">
            <.badge status={incident.status} />
          </:col>
          <:col :let={{_dom_id, incident}} label="Priority">
            {incident.priority}
          </:col>
        </.table>
      </.header>
    </div>
    """
  end
end
