defmodule ExPrimaToolbox.Task.Version do
  @moduledoc """
  version task

  output the actual app version to stdut or to a file
  """

  use ExPrimaToolbox.Task

  def run!(context) do
    if context.verbose > 0 do
      write "Running version command"
    end
    write("mix file: " <> mix_file)
    write "app name: :" <> to_string(app_name)
    write :success, "version: " <> version
    print_to_file(context)
  end

  def version do
    mix_project.project[:version]
  end

  defp print_to_file(%{filename: filename}) do
    File.write! filename, version
  end
  defp print_to_file(_), do: nil
end
