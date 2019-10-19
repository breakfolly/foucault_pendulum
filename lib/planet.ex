defmodule Planet do
  defstruct(
    gravity: 9.8, 
    radius: 6400000
  )

  def new() do
    %Planet{}
  end
end
