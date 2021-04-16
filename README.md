# StoneBankingAPI

## Description

A simple banking API for STONKS 'Programa de Formação Elixir'.

## Running the server in 3 steps

1 -  Start the PostgreSQL container with 
```sh
docker-compose up
```

2 - Configure the application with
```sh
mix setup
```

3 - Finally, start the server with
```sh
mix phx.server
```
## Testing

Run 
```sh
mix test
```
in your terminal

## Documentation
### Swagger docs (incomplete)
Start the server and point your browser to `localhost:4000/api/swagger`
