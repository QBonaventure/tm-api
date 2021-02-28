defmodule UbiNadeoApi.Type.DedicatedServer do
  alias __MODULE__

    @table_name :server_version
    @enforce_keys [
      :version,
      :release_datetime,
      :download_link,
      :status
    ]

    defstruct [
      version: nil,
      release_datetime: nil,
      download_link: nil,
      status: :ok
    ]

    @type t() :: %__MODULE__{
      version: Integer.t(),
      release_datetime: DateTime.t(),
      download_link: String.t(),
      status: Atom.t(),
    }

    def new(version, release_datetime, download_link, status \\ :ok) do
      %__MODULE__{version: version, release_datetime: release_datetime, download_link: download_link, status: status}
    end

    def to_mnesia_record(%DedicatedServer{} = dedi) do
      {:server_version, dedi.version, dedi.release_datetime, dedi.download_link, dedi.status}
    end
    def from_mnesia_record({@table_name, version, release_datetime, download_link, status}) do
      %__MODULE__{version: version, release_datetime: release_datetime, download_link: download_link, status: status}
    end

    def mnesia_attributes(), do: @enforce_keys
    def mnesia_table_name(), do: @table_name


    def save(%__MODULE__{} = version) do
      res =
        :mnesia.transaction(fn ->
          key = :mnesia.write(to_mnesia_record(version))
          :mnesia.read({@table_name, key})
        end)
    end

    def last_version() do
      {:atomic, [last_version_record]} =
        :mnesia.transaction(fn ->
          key = :mnesia.last(@table_name)
          :mnesia.read({@table_name, key})
        end)
      {:ok, from_mnesia_record(last_version_record)}
    end

    def list() do
      {:atomic, list} =
        :mnesia.transaction(fn ->
          key = :mnesia.match_object({@table_name, :_, :_, :_, :ok})
        end)
      {:ok, Enum.map(list, &from_mnesia_record(&1))}
    end

    def version_exist?(version) when is_integer(version) do
      query = fn -> key = :mnesia.read({@table_name, version}) end
      case :mnesia.transaction(query) do
        {:atomic, [record]} -> true
        {:atomic, []} -> false
      end
    end

end
