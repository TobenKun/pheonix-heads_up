defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _sessions, socket) do
    IO.inspect(self(), label: "MOUNT")
    {:ok, assign(socket, responders: 0, minutes_per_responder: 10)}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <div class="effort">
      <section>
        <button phx-click="add" phx-value-quantity="3">
          + 3
        </button>
        <div>
          {@responders}
        </div>
        &times;
        <div>
          {@minutes_per_responder}
        </div>
        =
        <div>
          {@responders * @minutes_per_responder}
        </div>
      </section>

      <form phx-submit="recalculate">
        <label>Minutes Per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    IO.inspect(self(), label: "ADD")
    socket = update(socket, :responders, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  def handle_event("recalculate", %{"minutes" => minutes}, socket) do
    IO.inspect(self(), label: "RECALCULATE")
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))

    {:noreply, socket}
  end
end
