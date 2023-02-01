#!/bin/sh
echo "Starting the server, it might take some time"
echo "Once launched, access http://localhost:8000/docs to see how to use the API"
uvicorn app:app
