#!/bin/sh
run_number=$RANDOM
echo "Running k6 scripts "$run_number
mkdir $run_number-outputs
echo "Running fastapi-optimum-onnx-arm"
k6 run --out json=$run_number-outputs/fastapi-optimum-onnx-arm.json --env URL=$fastapi_optimum_onnx_arm_dns_name script.js
echo "Running fastapi-optimum-onnx-amd"
k6 run --out json=$run_number-outputs/fastapi-optimum-onnx-amd.json --env URL=$fastapi_optimum_onnx_amd_dns_name script.js
echo "Running fastapi-trivial-arm"
k6 run --out json=$run_number-outputs/fastapi-trivial-arm.json --env URL=$fastapi_trivial_arm_dns_name script.js
echo "Running fastapi-trivial-amd"
k6 run --out json=$run_number-outputs/fastapi-trivial-amd.json --env URL=$fastapi_trivial_amd_dns_name script.js
