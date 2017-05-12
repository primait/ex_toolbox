defmodule ExPrimaToolbox.Task do
  @moduledoc """
  common task module
  """
  defmacro __using__(_) do
    quote do
      use ExPrimaToolbox.Aliases
      import ExPrimaToolbox.Task
    end
  end

  def mix_project do
    Mix.Project.get()
  end

  def app_name do
    mix_project().project[:app]
  end

  def mix_file do
    "#{File.cwd!}/mix.exs"
  end

  def write(:exit), do: IO.puts [color_exit(), "PRIMA> ", color_reset(), "exit"]
  def write(msg), do: IO.puts [color(), "PRIMA> ", color_reset(), msg]
  def write(:exit, msg), do: IO.puts [color_exit(), "PRIMA> ", color_reset(), msg]
  def write(:skip, msg), do: IO.puts [color_exit(), "PRIMA> ", color_reset(), msg]
  def write(:success, msg), do: IO.puts [color_success(), "PRIMA> ", color_reset(), msg]
  def write(:question, msg), do: IO.puts [color_question(), "PRIMA> ", color_reset(), msg]
  def write(:cmd, msg), do: IO.puts [color_command(), "EXEC> ", color_reset(), msg]
  def write(:yesno, msg, default \\ true) do
    response = IO.gets [color_question(), "PRIMA> ", color_reset(), msg]
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
  def color_command, do: IO.ANSI.white
  def color_reset, do: IO.ANSI.reset
  def color_exit, do: IO.ANSI.magenta
  def color_success, do: IO.ANSI.green
end
