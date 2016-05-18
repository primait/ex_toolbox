defmodule Mix.Tasks.Prima.Bump do
  @moduledoc """
  Bump della versione nel mix.exs file e tag della release
  """
  @shortdoc "Bump della versione e git tag"
  use Mix.Task

  def write(msg), do: IO.puts [color, "PRIMA> ", color_reset, msg]
  def write(:exit, msg), do: IO.puts [color_exit, "PRIMA> ", color_reset, msg]
  def write(:success, msg), do: IO.puts [color_success, "PRIMA> ", color_reset, msg]
  def write(:question, msg), do: IO.puts [color_question, "PRIMA> ", color_reset, msg]
  def write(:yesno, msg, default \\ true) do
    response = IO.gets [color_question, "PRIMA> ", color_reset, msg]
    case String.strip(response) do
      ""    -> default
      "y"   -> true
      "yes" -> true
      "1"   -> true
      _     -> false
    end
  end

  def color, do: IO.ANSI.yellow
  def color_question, do: IO.ANSI.cyan
  def color_reset, do: IO.ANSI.reset
  def color_exit, do: IO.ANSI.magenta
  def color_success, do: IO.ANSI.green

  def run(opts) do
    opts
    |> parse
    |> run!
  end

  def parse(options) do
    defaults = [increment: "patch", no_interaction: false, environment: nil]
    {parsed, _, _}  = options
    |> OptionParser.parse(aliases: [i: :increment, n: :no_interaction, e: :environment])
    Keyword.merge(defaults, parsed)
  end

  def run!([increment: increment, no_interaction: no_interaction, environment: environment]) do
    actual_version = Urania.Mixfile.project[:version]
    write "actual version is #{actual_version}"
    {:ok, version} = Version.parse(actual_version)
    new_version = do_increment(version, increment)
    write "new version will be #{new_version}"
    unless no_interaction do
      proceed = write :yesno, "is it ok? [Y/n]"
      unless proceed do
        write :exit, "esco..."
        exit(0)
      end
    end

    write "overwrite mix.exs file"
    content = File.read!(mix_file)
    new_content = String.replace(content, ~r/version: "#{actual_version}"/, "version: \"#{new_version}\"")
    File.write!(mix_file, new_content)
    System.cmd "git", ["commit", "-am", "\"new version #{new_version}\""], into: IO.stream(:stdio, :line)
    System.cmd "git", ["tag", tag_name(new_version, environment)], into: IO.stream(:stdio, :line)
    write "tag #{tag_name(new_version, environment)} creato"
    System.cmd "git", ["push"], into: IO.stream(:stdio, :line)
    System.cmd "git", ["push", "--tags"], into: IO.stream(:stdio, :line)
    write "push su github"
    write :success, "fatto!"
  end

  def tag_name(version, nil), do: "#{version}"
  def tag_name(version, environment), do: "#{version}-#{environment}"


  def do_increment(version, "patch") do
    %{version | patch: version.patch + 1}
  end
  def do_increment(version, "minor") do
    %{version | minor: version.minor + 1, patch: 0}
  end
  def do_increment(version, "major") do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  defp mix_file do
    "#{File.cwd!}/mix.exs"
  end
end
