#!/bin/sh
cd "$(dirname "$0")"/..

which bundle >/dev/null && bundle exec which docker-sync >/dev/null && TTE_DOCKER_SYNC=-sync
export TTE_ROOT=`pwd`
export TTE_SERVICES="tte-front-dev"
export TTE_PRE_BUILD_SERVICES="tte-front"
export TTE_SERVICE="$(echo $TTE_SERVICES|cut -d' ' -f1)"
export TTE_DOCKER_COMPOSE="-f docker-compose.yml -f docker-compose-dev${TTE_DOCKER_SYNC}.yml"
export TTE_UID=$(id -u)

mkdir -p "${TTE_ROOT}/tmp/home/${USER}/.local/bin"

[ -n "$TTE_DOCKER_SYNC" ] && bundle exec docker-sync start
docker-compose $TTE_DOCKER_COMPOSE build $TTE_PRE_BUILD_SERVICES
docker-compose $TTE_DOCKER_COMPOSE build $TTE_SERVICES
docker-compose $TTE_DOCKER_COMPOSE up -d $TTE_SERVICES
docker-compose $TTE_DOCKER_COMPOSE exec $TTE_SERVICE bash -li
[ -n "$TTE_DOCKER_SYNC" ] && bundle exec docker-sync stop
docker-compose $TTE_DOCKER_COMPOSE down -v
