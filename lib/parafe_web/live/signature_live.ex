defmodule ParafeWeb.SignatureLive do
  use ParafeWeb, :live_view
  alias Parafe.{Crypto, Parameters, Signature, Signatures}
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      assign(
        socket,
        input_params: Parameters.changeset(%Parameters{}),
        signature: %Signature{}
      )
    }
  end

  @impl true
  def handle_event("sign", %{"parameters" => params}, socket) do
    Logger.info("Signing the request")

    signature =
      %Parameters{}
      |> Parameters.changeset(params)
      |> Signatures.sign()

    {:noreply, assign(socket, signature: signature)}
  end

  @impl true
  def handle_event("validate", %{"parameters" => params}, socket) do
    params =
      %Parameters{}
      |> Parameters.changeset(params)
      |> Map.put(:action, :insert)
    Logger.info("Validate input parameters")

    {:noreply, assign(socket, input_params: params, enable_submit: params.valid?)}
  end

  @impl true
  def handle_event("generate_private_key", _, socket) do
    Logger.info("Generate private key")

    key = Crypto.generate_private_key()
    socket = update(socket, :input_params, &Parameters.set_private_key(&1, key))

    {:noreply, socket}
  end
end
