#!/bin/sh
echo "Starting the docker image locally"
docker run --name fastapi-optimum-onnx -d -p 8001:80 airklizz/fastapi-optimum-onnx:latest
docker run --name fastapi-trivial -d -p 8002:80 airklizz/fastapi-trivial:latest