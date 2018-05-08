#!/bin/sh
cd "$(dirname "$0")"/..

export TTE_ROOT=`pwd`
export TTE_SERVICES="tte-front-dev"
export TTE_PRE_BUILD_SERVICES="tte-front"
export TTE_SERVICE="$(echo $TTE_SERVICES|cut -d' ' -f1)"
export TTE_DOCKER_COMPOSE="-f docker-compose.yml -f docker-compose-dev.yml"
export TTE_UID=$(id -u)

mkdir -p "${TTE_ROOT}/tmp/home/${USER}/.local/bin"

docker-compose $TTE_DOCKER_COMPOSE build $TTE_PRE_BUILD_SERVICES
docker-compose $TTE_DOCKER_COMPOSE build $TTE_SERVICES
docker-compose $TTE_DOCKER_COMPOSE up -d $TTE_SERVICES
docker-compose $TTE_DOCKER_COMPOSE exec $TTE_SERVICE bash -li
docker-compose $TTE_DOCKER_COMPOSE down -v
