defmodule Parafe.Signatures do
  import Ecto.Changeset
  alias Parafe.{Parameters, Signature, SignatureBuilder}

  @spec sign(Parameters.t()) :: Signature.t()
  def sign(%Parameters{} = params) do
    {:ok, headers} = SignatureBuilder.signature_headers(params)

    %Signature{
      digest: Keyword.fetch!(headers, :Digest),
      signature_string: Keyword.fetch!(headers, :Signature)
    }
  end

  def sign(%Ecto.Changeset{} = changeset) do
    changeset
    |> apply_changes()
    |> sign()
  end
end
