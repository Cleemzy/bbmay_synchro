defmodule Bebemayotte.Utilities do

  def splice(list) do
    list
    |> Enum.split(trunc((list|>length)/2))
  end

end
