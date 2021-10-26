.PHONY: down build db reset-db up test

down:
	docker-compose down

build:
	docker-compose build

db:
	docker-compose run web mix ecto.setup

reset:
	docker-compose run web mix ecto.reset

up: down build |
	docker-compose up

test: down build |
	docker-compose run --rm -e "MIX_ENV=test" web mix test
