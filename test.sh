#!/bin/bash

NETWORK=$(docker network create test-network)
DB_CONTAINER=$(docker run -d --rm -e POSTGRES_PASSWORD=docker --network test-network  --name test-db -d postgres)

# test lambda proxy
TEST_CONTAINER_LAMBDA=$(docker run -d --network test-network -p 8080:8080 -e DATABASE_HOST=test-db -e DJANGO_SETTINGS_MODULE=django_serverless.settings.dev django-serverless)
sleep 3
curl -X POST -d '{"headers":{"host":"localhost"}, "path": "/", "httpMethod": "GET", "requestContext": {}, "body": ""}' "http://localhost:8080/2015-03-31/functions/function/invocations" | jq -r '.body' > lambda_response.html
docker kill ${TEST_CONTAINER_LAMBDA}

# test django local
TEST_CONTAINER=$(docker run -d --network test-network -p 8080:8000 -e DATABASE_HOST=test-db -e DJANGO_SETTINGS_MODULE=django_serverless.settings.dev --entrypoint python  django-serverless manage.py runserver 0.0.0.0:8000)
sleep 3
curl -GET "http://localhost:8080/" > local_response.html
docker kill ${TEST_CONTAINER}

docker kill ${DB_CONTAINER}
docker network rm ${NETWORK}