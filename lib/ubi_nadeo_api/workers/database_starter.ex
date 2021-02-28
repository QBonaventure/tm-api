defmodule UbiNadeoApi.Worker.DatabaseStarter do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    UbiNadeoApi.Database.start()
    UbiNadeoApi.Database.create_table(
      UbiNadeoApi.Type.DedicatedServer.mnesia_table_name(),
      UbiNadeoApi.Type.DedicatedServer.mnesia_attributes()
    )
    {:ok, %{last_run_at: :calendar.local_time()}}
  end

end
