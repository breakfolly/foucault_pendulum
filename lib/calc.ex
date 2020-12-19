defmodule Calc do
  defp init_values do
    %{
      gravity: 9.8,
      radius: 6_400_000
    }
  end

  def get_init() do
    init_values() 
  end
end
