defmodule ParafeWeb.SignatureLive do
  use ParafeWeb, :live_view
  alias Parafe.{Parameters, Signature, Signatures}
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
    Logger.info("Validate input parameters")

    params = Parameters.changeset(%Parameters{}, params)

    {:noreply, assign(socket, input_params: params, enable_submit: params.valid?)}
  end
end
