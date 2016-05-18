defmodule ExToolbox.Task.Version do
  use ExToolbox.Task

  def run!(context) do
    if context.verbose > 0 do
      write "Running version command"
    end
    write :success, version
    print_to_file(context, version)
  end

  def version do
    mix_project.project[:version]
  end

  defp print_to_file(%{filename: filename}, version) do
    File.write! filename, version
  end
  defp print_to_file(_, _), do: nil
end
