defmodule ParafeWeb.SignatureLive do
  use ParafeWeb, :live_view
  alias Parafe.{Parameters, Signature, Signatures}
  import Ecto.Changeset

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      assign(socket,
        input_params: change(%Parameters{}) |> IO.inspect(),
        signature: %Signature{},
        enable_submit: false,
        http_methods: list_methods())}
  end

  @impl true
  def handle_event("sign", %{"parameters" => params}, socket) do
    signature =
      params
      |> Parameters.changeset()
      |> Signatures.sign()

    {:noreply, assign(socket, signature: signature)}
  end

  @impl true
  def handle_event("validate", %{"parameters" => params}, socket) do
    params =
      params
      |> Parameters.changeset()
      |> Map.put(:action, :insert)
      |> IO.inspect()

    {:noreply, assign(socket, input_params: params, enable_submit: params.valid?)}
  end

  defp list_methods do
    ~w(GET POST PATCH)
  end
end
