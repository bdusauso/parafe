defmodule Parafe.Crypto do
  @moduledoc """
  Cryptographic helpers
  """

  @spec generate_private_key() :: String.t()
  def generate_private_key do
    with {:ok, rsa_priv_key} <- ExPublicKey.generate_key(2048),
         {:ok, pem_string} <- ExPublicKey.pem_encode(rsa_priv_key) do
      pem_string
    end
  end
end
