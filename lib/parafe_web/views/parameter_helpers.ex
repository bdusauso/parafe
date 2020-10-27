defmodule ParafeWeb.ParameterHelpers do
  @moduledoc """
  Convenience methods to work with Parameters.
  """

  def http_methods, do: Parafe.Parameters.http_methods()

  def valid?(parameters), do: !parameters.valid? || !parameters.action
end
