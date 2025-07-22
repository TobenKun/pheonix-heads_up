defmodule HeadsUp.Tips do
  def list_tips do
    [
      %{
        id: 1,
        text: "Slow is smooth, and smooth is fast!"
      },
      %{
        id: 2,
        text: "Working with a buddy is always a smart move."
      },
      %{
        id: 3,
        text: "Take it easy and enjoy!"
      }
    ]
  end

  def get_tip(id) when is_integer(id) do
    Enum.find(list_tips(), fn e -> e.id == id end)
  end

  def get_tip(id) when is_binary(id) do
    String.to_integer(id) |> get_tip()
  end
end
