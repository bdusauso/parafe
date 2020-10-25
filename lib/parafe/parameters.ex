defmodule Parafe.Parameters do
  use Ecto.Schema
  import Ecto.Changeset

  @cast_fields ~w(method url payload private_key key_id)a
  @required_fields @cast_fields

  embedded_schema do
    field :method, :string, default: "GET"
    field :url, :string
    field :payload, :string
    field :private_key, :string
    field :key_id, :string
    field :headers_string, :string
    field :headers, {:array, :string}
  end

  def changeset(parameters) do
    %__MODULE__{}
    |> cast(parameters, @cast_fields)
    |> validate_required(@required_fields)
    |> validate_private_key()
    |> validate_payload()
    |> validate_url()
    |> validate_headers()
  end

  defp validate_payload(changeset) do
    validate_change(
      changeset,
      :payload,
      fn :payload, payload ->
        case Jason.decode(payload) do
          {:ok, _} ->
            []

          {:error, _} ->
            [{:payload, "must be a valid JSON"}]
        end
      end
    )
  end

  defp validate_private_key(changeset) do
    validate_change(
      changeset,
      :private_key,
      fn :private_key, key ->
        case ExPublicKey.loads(key) do
          {:ok, _} ->
            []

          {:error, _} ->
            [{:private_key, "must be a valid private key encoded in PEM format"}]
        end
      end)
  end

  def validate_url(changeset) do
    validate_change(
      changeset,
      :url,
      fn :url, url ->
        uri = URI.parse(url)
        if is_nil(uri.host)
          or uri.scheme not in ["http", "https"],
          do: [{:url, "must be a well formed URL"}],
          else: []
      end
    )
  end

  # defp split_headers(changeset) do
  #   changeset
  #   |> get_field(:headers)
  #   |> String.split("\n")
  # end

  defp validate_headers(changeset) do
    validate_change(
      changeset,
      :headers,
      fn :headers, headers ->
        headers =
          headers

        Enum.reduce(headers, [], fn _elem, errors ->
          errors
        end)
      end)
  end
end
