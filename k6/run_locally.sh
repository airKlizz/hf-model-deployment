#!/bin/sh
echo "Running k6 scripts "
mkdir outputs
echo "Running fastapi-optimum-onnx"
k6 run --out json=outputs/fastapi-optimum-onnx.json --env URL=localhost:8001 script.js
echo "Running fastapi-trivial"
k6 run --out json=outputs/fastapi-trivial.json --env URL=localhost:8002 script.js
