defmodule Mix.Tasks.Prima.Artifact do
  @moduledoc """
  Create an urania artifact, based on the version number

    -e environment
  """
  @shortdoc "Create an urania artifact"

  use Mix.Task

  def run(options) do
    options
    |> parse
    |> run!
  end

  def parse(options) do
    opts = options
    |> OptionParser.parse(aliases: [e: :env])
    {switches, other, other2} = opts
    switches = switches
    |> Keyword.put_new(:env, "staging")
    |> Keyword.put_new(:skip_release, false)
    {switches, other, other2}
  end

  def version do
    Mix.Project.config[:version]
  end

  def release_path do
    "#{root_dir}/rel/urania/releases/#{version}/urania.tar.gz"
  end

  def dockerrun_file do
    "#{root_dir}/deploy/Dockerrun.aws.json"
  end

  def tar_file(env) do
    "#{root_dir}/deploy/#{version}-#{env}.tar.gz"
  end

  def write(msg), do: IO.puts [color, "PRIMA> ", color_reset, msg]

  def color, do: IO.ANSI.yellow
  def color_reset, do: IO.ANSI.reset

  def root_dir, do: File.cwd!
  def tmp_dir, do: "/tmp/urania_#{version}"

  def run!(opts = {[skip_release: _, env: env], _, _}) do
    write "Deploying app in env #{env}, version: #{version}"
    opts
    |> IO.inspect
    |> digest
    |> clean_old_release
    |> build_release
    |> copy_release
  end

  def digest(opts) do
    write "phoenix digest"
    System.cmd "mix", ["phoenix.digest"], into: IO.stream(:stdio, :line)
    opts
  end

  def clean_old_release(opts = {[skip_release: false], _, _}) do
    write "clean old release"
    System.cmd "mix", ["release.clean"], into: IO.stream(:stdio, :line)
    opts
  end
  def clean_old_release(opts), do: opts

  def build_release(opts = {switches, _, _}) do
    unless switches[:skip_release] do
      write "build #{switches[:env]} release"
      System.cmd "mix", ["compile"], env: [{"MIX_ENV", switches[:env]}], into: IO.stream(:stdio, :line)
      System.cmd "mix", ["deps.compile"], env: [{"MIX_ENV", switches[:env]}], into: IO.stream(:stdio, :line)
      System.cmd "mix", ["release"], env: [{"MIX_ENV", switches[:env]}], into: IO.stream(:stdio, :line)
    end
    opts
  end

  def copy_release(opts = {[skip_release: _, env: env], _, _}) do
    write "copying tar to #{tar_file(env)}"
    File.copy release_path, tar_file(env)
    opts
  end

end
