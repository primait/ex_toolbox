defmodule ExPrimaToolbox do
  @moduledoc """
  prima toolbox
  """
  use ExPrimaToolbox.Aliases
  use ExCLI.DSL, mix_task: :prima

  name "prima"
  description "prima toolbox"
  long_description ~s"""
  collection of tools from the prima toolbox
  """

  option :verbose, count: true, aliases: [:v]

  command :version do
    description "prints the version of the application to the standard output, or to a file"
    option :filename, help: "file to write version to", default: :empty, aliases: [:f]

    run context do
      VersionTask.run!(context)
    end
  end

  command :bump do
    description "bump the project version and optionally create git tags"
    option :dry, type: :boolean, default: false, help: "do not write or commit anything, just print to stdout"
    option :patch, type: :boolean, help: "upgrade the patch version"
    option :minor, type: :boolean, help: "upgrade the minor version"
    option :major, type: :boolean, help: "upgrade the major version"
    option :env, default: "", help: "environment"
    option :git, default: true, type: :boolean, help: "perform git operations"

    run context do
      BumpTask.run!(context)
    end
  end
end
