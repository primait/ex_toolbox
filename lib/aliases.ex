defmodule Aliases do
  defmacro __using__(_) do
    quote do
      alias ExToolbox.Task.Bump, as: BumpTask
      alias ExToolbox.Task.Version, as: VersionTask
    end
  end
end
