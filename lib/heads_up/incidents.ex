defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~W(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [r], ilike(r.name, ^"%#{q}%"))
  end

  defp sort_option("name"), do: :name
  defp sort_option("priority_desc"), do: [desc: :priority]
  defp sort_option("priority_asc"), do: [asc: :priority]
  defp sort_option(_), do: :id

  defp sort(query, sort_by) do
    order_by(query, ^sort_option(sort_by))
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    Incident
    |> where(status: :pending)
    |> where([r], r.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
