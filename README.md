# ExPrimaToolbox

Some tasks to deploy, build and manage our elixir microservices

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ex_prima_toolbox to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_prima_toolbox, "~> 0.0.1"}]
        end

  2. Ensure ex_prima_toolbox is started before your application:

        def application do
          [applications: [:ex_prima_toolbox]]
        end
