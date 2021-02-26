defmodule UbiNadeoApi.Type.Query do
  alias __MODULE__

  defstruct [
    uri: nil,
    method: nil,
    resource: nil,
    path: [],
    parameters: [],
  ]

  @type t() :: %__MODULE__{
    uri: Stgring.t(),
    method: Atom.t(),
    resource: Atom.t(),
    path: List.t(),
    parameters: Keyword.t(),
  }

  @allowed_query_parts ["sort_by", "from_date"]
  @allowed_method ["GET", "POST", "HEAD", "PUT"]

  def from_conn(%Plug.Conn{method: method, path_info: path, query_params: query} = conn) do
    [resource, path] = split_path(path)
    %Query{
      method: atomize_method(method),
      resource: String.to_atom(resource),
      path: path,
      parameters: sanitize_params(query),
      uri: rebuild_uri(conn)
    }
  end

  def rebuild_uri(%Plug.Conn{} = conn), do:
    "#{conn.request_path}?#{conn.query_string}"

  defp atomize_method(method) when method in @allowed_method do
    method
    |> String.downcase()
    |> String.to_atom()
  end

  # def from_uri(method, uri) do
  #   [[resource, path], params] =
  #     case String.trim(uri, "/") |> String.split("?") do
  #       [path] -> [split_path(path), nil]
  #       [path, params] -> [split_path(path), decode_params(params)]
  #     end
  #
  #   %Query{uri: uri, resource: resource, path: path, parameters: params}
  # end

  def split_path([]), do: [nil, nil]
  def split_path([resource]), do: [resource, nil]
  def split_path([resource | path]) do
    [resource, path]
  end

  defp sanitize_params(params) do
    params
    |> Enum.filter(fn {key, _value} -> key in @allowed_query_parts end)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
  end

end
