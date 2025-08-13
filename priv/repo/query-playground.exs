alias HeadsUp.Repo
alias HeadsUp.Incidents
alias HeadsUp.Incidents.Incident
import Ecto.Query

# 전체 출력
Repo.all(Incident) |> IO.inspect()

IO.puts("------------------------------------\n\n\n\n\n\n------------------------------------")

# all the pending incidents, ordered by descending priority 
Incident
  |> where(status: :pending)
  |> order_by(desc: :name)
  |> Repo.all()
  |> IO.inspect()

IO.puts("------------------------------------\n\n\n\n\n\n------------------------------------")

# incidents with a priority greater than or equal to 2, ordered by ascending name 
Incident
  |> where([r], r.priority >= 2)
  |> order_by(asc: :name)
  |> Repo.all()
  |> IO.inspect()

IO.puts("------------------------------------\n\n\n\n\n\n------------------------------------")

# incidents that have "meow" anywhere in the description
Incident
  |> where([r], ilike(r.description, "%meow%"))
  |> Repo.all()
  |> IO.inspect()

IO.puts("------------------------------------\n\n\n\n\n\n------------------------------------")

# the first and last incident
Incident
  |> first()
  |> Repo.one()
  |> IO.inspect()

Incident
  |> last()
  |> Repo.one()
  |> IO.inspect()

IO.puts("------------------------------------\n\n\n\n\n\n------------------------------------")

# id가 짝수인 것만
# ecto에서 DB 함수나 연산자를 호출할 떄는 fragment/1를 써야한다
Incident
  |> where([r], fragment("? % 2 = 0", r.id))
  |> Repo.all()
  |> IO.inspect()
