# MessageProcessing

##### TO BUILD DOCKER EXECUTE: `docker-compose up` 
##### Subscribe to topics with telnet: `telnet 127.0.0.1 8000`
##### Possible topics: negative, neutral, positive

```
telnet 127.0.0.1 8000
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
neutral # this is the topic you want to subscribe to.
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `message_processing` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:message_processing, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/message_processing](https://hexdocs.pm/message_processing).

