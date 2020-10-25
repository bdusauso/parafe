defmodule Parafe.SignatureBuilder do
  @moduledoc false

  alias Parafe.Parameters

  @empty_sha512sum "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg_SpIdNs6c5H0NE8XYXysP-DGNKHfuwvY7kxvUdBeoGlODJ6-SfaPg=="
  @algorithm "hs2019"

  def signature_headers(%Parameters{} = parameters) do
    headers = [
      Digest: "SHA-512=" <> payload_digest(parameters.payload),
      Signature: generate_signature(parameters)
    ]

    {:ok, headers}
  end

  defp payload_digest(payload) do
    payload
    |> ExCrypto.Hash.sha512!()
    |> Base.encode64()
  end

  defp generate_signature(parameters) do
    timestamp = DateTime.to_unix(DateTime.utc_now())
    headers = signing_headers(parameters, timestamp)

    signing_headers =
      headers
      |> Keyword.keys()
      |> Enum.join(" ")

    signature =
      headers
      |> Enum.join("\n")
      |> sign(parameters.private_key)
      |> Base.url_encode64()

    Enum.join(
      [
        ~s/keyId="#{parameters.key_id}"/,
        ~s/created="#{timestamp}"/,
        ~s/algorithm="#{@algorithm}"/,
        ~s/headers="#{signing_headers}"/,
        ~s/signature="#{signature}"/,
      ],
      ","
    )
  end

  defp signing_headers(parameters, timestamp) do
    uri = URI.parse(parameters.url)

    []
    |> add_request_target(parameters.method, uri)
    |> add_host(uri)
    |> add_created(timestamp)
    |> add_digest(parameters.method)
    |> Enum.reverse()
  end

  defp sign(msg, private_key_pem) do
    with {:ok, private_key} <- ExPublicKey.loads(private_key_pem),
         {:ok, pri_key_seq} <- ExPublicKey.RSAPrivateKey.as_sequence(private_key) do
      :public_key.sign(msg, :sha256, pri_key_seq, rsa_padding: :rsa_pkcs1_pss_padding)
    end
  end

  defp add_request_target(headers, method, uri) do
    uri_path = if uri.query, do: uri.path <> "?" <> uri.query, else: uri.path
    Keyword.put_new(headers, :"(request-target)", "#{method} #{uri_path}")
  end

  defp add_created(headers, timestamp) do
    Keyword.put_new(headers, :"(created)", timestamp)
  end

  defp add_host(headers, uri) do
    Keyword.put_new(headers, :host, uri.host)
  end

  defp add_digest(headers, payload) do
    Keyword.put_new(headers, :digest, "SHA-512=" <> payload_digest(payload))
  end
end

defimpl String.Chars, for: Tuple do
  def to_string({key, value}) when is_atom(key) do
    "#{key}: #{value}"
  end
end
