defmodule BeamToolboxData do
  use Application

  def start(_type, _args) do
    BeamToolboxData.Supervisor.start_link
  end
end
