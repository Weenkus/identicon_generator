# Identicon

An elixir module for creating identicons. Read more on identicons here https://en.wikipedia.org/wiki/Identicon.

## Documentation

Documentation is wrriten using `ex_doc 1.4`, it is in the `doc` folder. To view the whole documentation, run `index.html` with the browser of your choice.

## Tests

The module has no specific unit tests except doc tests that can be run with `mix` tools.

  ```elixir
  iex -S mix
  mix test
  ```
    
## Examples

Examples of identicon for Joe, Weenkus and Mary (input string in the identicon module).

![alt tag](https://raw.githubusercontent.com/Weenkus/identicon/master/identicon_examples/Joe.png)
![alt tag](https://raw.githubusercontent.com/Weenkus/identicon/master/identicon_examples/Weenkus.png)
![alt tag](https://raw.githubusercontent.com/Weenkus/identicon/master/identicon_examples/Mary.png)

To generate your own identicon, use the `mix` tool.

  ```elixir
  iex -S mix
  Identicon.create("Your_name")
  ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `identicon` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:identicon, "~> 1.0.0"}]
    end
    ```

  2. Ensure `identicon` is started before your application:

    ```elixir
    def application do
      [applications: [:identicon]]
    end
    ```

