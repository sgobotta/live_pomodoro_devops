.PHONY: help start stop setup test

# ------------------------------------------------------------------------------
# Environment setup
#

BINS_DIR = ./bin
ENV_FILE ?= .env
COMPOSE_DIR ?= devops/
REDIS_DIR ?= devops/apps/redis
POSTGRES_DIR ?= devops/apps/postgres

# add env variables if needed
ifneq (,$(wildcard ${ENV_FILE}))
	include ${ENV_FILE}
    export
endif

export GREEN=\033[0;32m
export NOFORMAT=\033[0m

# ------------------------------------------------------------------------------
# Commands
#

default: help

#❓ help: @ Displays this message
help: SHELL:=/bin/bash
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "${GREEN}%-30s${NOFORMAT} %s\n", $$1, $$2}'

#♻️  cache.backup: @   Creates a backup of the redis cache
cache.backup: SHELL:=/bin/bash
cache.backup: BACKUP_NAME:=dump_`date +%d-%m-%Y"_"%H_%M_%S`
cache.backup:
	@docker run --rm --volumes-from pomodoro_redis_service -v $(shell pwd)/$(REDIS_DIR)/backup:/backup ubuntu tar cvf /backup/redis_${BACKUP_NAME}.tar /data

#♻️  cache.restore: @   Restores a cache backup for the redis service
cache.restore: SHELL:=/bin/bash
cache.restore: BACKUP_NAME:=$(BACKUP_NAME)
cache.restore:
	@docker run --rm --volumes-from pomodoro_redis_service -v $(shell pwd)/$(REDIS_DIR)/backup:/backup ubuntu bash -c "cd /data && tar xvf /backup/$(BACKUP_NAME) --strip 1"
	@cd $(COMPOSE_DIR) && docker compose restart redis

#♻️  db.backup: @   Creates a backup of the postgres db
db.backup: SHELL:=/bin/bash
db.backup: DB_USERNAME:=$(DB_USERNAME)
db.backup: BACKUP_NAME:=dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
db.backup:
	@docker exec -t pomodoro_postgres_service pg_dumpall -c -U ${DB_USERNAME} > $(shell pwd)/$(POSTGRES_DIR)/backup/pg_${BACKUP_NAME}

#♻️  db.restore: @   Restores a db backup for the postgres service
db.restore: SHELL:=/bin/bash
db.restore: DB_USERNAME:=${DB_USERNAME}
db.restore: DUMP_FILE:=$(DUMP_FILE)
db.restore:
	@cat $(shell pwd)/$(POSTGRES_DIR)/backup/${DUMP_FILE} | docker exec -i pomodoro_postgres_service psql -U ${DB_USERNAME}
	@echo "Postgres backup finished."

#🐳 redis.cli: @ Starts a redis instance
redis.cli: SHELL:=/bin/bash
redis.cli: REDIS_PASS:=${REDIS_PASS}
redis.cli:
	@cd $(COMPOSE_DIR) && docker compose exec redis sh -c 'redis-cli -a ${REDIS_PASS}'

#🎁 redis.flush: @ Convenience funcion to flush redis keys in docker-compose deployments.
redis.flush: REDIS_PASS:=${REDIS_PASS}
redis.flush:
	@cd ${COMPOSE_DIR} && docker compose exec -e REDISCLI_AUTH=${REDIS_PASS} redis redis-cli FLUSHALL

#🚀 start: @ Starts tilt services
start: SHELL:=/bin/bash
start:
	@echo Starting Tilt...
	@cd ${COMPOSE_DIR} && tilt up

#🚫 stop: @ Stop tilt services
stop:
	@echo Stopping Tilt...
	@cd ${COMPOSE_DIR} && tilt down

#⬆️  devops.up:@   Starts up the `docker-compose.yaml` services located in ./devops
devops.up:
	@cd ${COMPOSE_DIR} && docker compose up

#⬇️  devops.down:@   Stops the `docker-compose.yaml` services located in ./devops
devops.down:
	@cd ${COMPOSE_DIR} && docker compose down

#💻 connect.dev: @ Start dev a tmux session
connect.dev: SESSION:=dev
connect.dev: DEV_USER:=${DEV_USER}
connect.dev: DEV_HOST:=${DEV_HOST}
connect.dev:
	@${BINS_DIR}/tmux.sh ${SESSION}
