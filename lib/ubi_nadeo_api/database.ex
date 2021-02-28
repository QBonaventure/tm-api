defmodule UbiNadeoApi.Database do

  def start() do
    :mnesia.create_schema([node()])
    :mnesia.start()
  end

  def create_table(table_name, attrs) do
    :mnesia.create_table(
      UbiNadeoApi.Type.DedicatedServer.mnesia_table_name(),
      access_mode: :read_write,
      disc_copies: [node()],
      type: :ordered_set,
      attributes: UbiNadeoApi.Type.DedicatedServer.mnesia_attributes()
    )
  end

end
