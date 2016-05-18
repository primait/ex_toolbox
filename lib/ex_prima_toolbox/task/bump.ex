defmodule ExPrimaToolbox.Task.Bump do
  @moduledoc """
  bump task
  upgrade the mix.exs version and tag/push a release
  """

  use ExPrimaToolbox.Task

  def run!(context) do
    if context.verbose > 0 do
      write "Running bump command"
    end
    actual_version = VersionTask.version
    write "actual version is #{actual_version}"
    new_version = actual_version
    |> Version.parse
    |> do_increment(context)
    write "new version will be #{new_version}"
    proceed = write :yesno, "is it ok? [Y/n]"
    unless proceed do
      write :exit
      exit(0)
    end

    write "overwrite mix.exs file in #{mix_file}"
    mix_file
    |> File.read!
    |> String.replace(~r/version: "#{actual_version}"/, "version: \"#{new_version}\"")
    |> write_file(context)

    git_operations(new_version, context)

    write :success, "fatto!"
  end

  defp git_operations(_, %{git: false}) do
    write :skip, "skipping git operations"
  end
  defp git_operations(new_version, context) do
    command "git", ["commit", "-am", "\"new version #{new_version}\""], context
    command "git", ["tag", tag_name(new_version, context[:env])], context
    write "tag #{tag_name(new_version, context[:env])} creato"
    write :success, "pushing on remote"
    command "git", ["push"], context
    write :success, "pushing tags on remote"
    command "git", ["push", "--tags"], context
  end

  defp do_increment({:ok, version}, %{major: true}) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end
  defp do_increment({:ok, version}, %{minor: true}) do
    %{version | minor: version.minor + 1, patch: 0}
  end
  defp do_increment({:ok, version}, _) do
    %{version | patch: version.patch + 1}
  end

  defp write_file(content, %{dry: true}) do
    write "new content"
    IO.puts content
  end
  defp write_file(content, %{dry: false}) do
    File.write!(mix_file, content)
  end

  defp command(cmd, args, %{dry: dry}) do
    write(:cmd, cmd <> " " <> Enum.join(args, " "))
    unless dry do
      System.cmd cmd, args, into: IO.stream(:stdio, :line)
    end
  end

  def tag_name(version, ""), do: "#{version}"
  def tag_name(version, environment), do: "#{version}-#{environment}"
end
