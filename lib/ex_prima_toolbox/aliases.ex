defmodule ExPrimaToolbox.Aliases do
  defmacro __using__(_) do
    quote do
      alias ExPrimaToolbox.Task.Bump, as: BumpTask
      alias ExPrimaToolbox.Task.Version, as: VersionTask
    end
  end
end
