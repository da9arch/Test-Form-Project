COMPOSE := docker-compose -p backend -f ./docker/docker-compose.yml
PHP_CONTAINER := php

up:
	$(COMPOSE) up -d --force-recreate

down:
	$(COMPOSE) down

enter-php:
	docker exec -ti $(PHP_CONTAINER) bash

build:
	$(COMPOSE) build

rebuild:
	$(COMPOSE) build --no-cache

install:
	rm -Rf docker/data || (sudo rm -Rf docker/data)
	rm -Rf docker/log || (sudo rm -Rf docker/log)
	rm -Rf vendor/ || (sudo rm -Rf vendor/)
	rm -Rf node_modules/ || (sudo rm -Rf node_modules/)
	mkdir docker/data
	mkdir docker/data/postgres
	cp docker/.env.dist docker/.env
	cp docker/docker-compose.override.local.yml docker/docker-compose.override.yml
	$(COMPOSE) build --no-cache
	$(COMPOSE) up -d --remove-orphans

clear:
	docker exec -ti $(PHP_CONTAINER) bin/console cache:clear
	docker exec -ti $(PHP_CONTAINER) bin/console doctrine:cache:clear-metadata

clear-var:
	rm -Rf var/
	chmod 777 var/log
	chmod 666 var/log/*.log
	rm -rf var/cache/*
	touch var/log/access.log
	touch var/log/error.log

watch:
	$(COMPOSE) exec php yarn watch

recreate-db:
	docker exec -ti $(PHP_CONTAINER) bin/console --env=dev doctrine:database:drop --force
	docker exec -ti $(PHP_CONTAINER) bin/console --env=dev doctrine:database:create
	docker exec -ti $(PHP_CONTAINER) bin/console --env=dev doctrine:migrations:migrate --no-interaction
