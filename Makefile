########################################################################################################################
## NECONOMICON - https://github.com/viduc/neconomicon                                                                 ##
## This file is a part of NECONOMICON application                                                                     ##
########################################################################################################################
include Makefile.vars
## —— INIT  ————————————————————————————————————————————————————————————————————
init:
	mkdir -p docker-volumes
	mkdir -p docker-volumes/nginx
	mkdir -p docker-volumes/php-fpm
	mkdir -p docker-volumes/php-fpm/session

	sudo chmod 777 -R docker-volumes

## —— Docker  ——————————————————————————————————————————————————————————————————
build: pcov-conf-enable
	@$(DOCKER) build -- --no-cache

up:
	@$(DOCKER) --env-file ./docker/.env.local up -d --no-recreate

down:
	@$(DOCKER) down --remove-orphans

restart: down up

pcov-conf-enable: docker-compose.yml
	sed -i "s/- ENABLE_PCOV=0/- ENABLE_PCOV=1/g" ./docker/php-fpm/Dockerfile

## —— Composer  ————————————————————————————————————————————————————————————————
composer-install:
	$(COMPOSER) install -n

composer-update: composer.lock
	$(COMPOSER) update -n

composer-dump-autoload:
	$(EXEC) bash -c "composer dump-autoload"

## —— NPM  —————————————————————————————————————————————————————————————————————
npm-watch:
	$(NPM) run watch
npm-dev:
	$(NPM) run dev
npm-install:
	$(NPM) install
## —— Installation  ————————————————————————————————————————————————————————————
install: init build up composer-install npm-install install-done

install-done:
	@echo "Installation réussie, vous pouvez ouvrir l'application à l'adresse http://localhost:99"
	@echo "Pour les prochaines fois, vous pourrez lancer le système avec la commande 'make up'"
	@echo "Pour arrêter le système, vous pourrez lancer la commande 'make down'"