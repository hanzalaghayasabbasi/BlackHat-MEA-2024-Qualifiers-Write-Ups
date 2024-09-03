#!/bin/bash

echo "Building challenge..."
docker compose build

echo "Starting challenge..."
docker compose up -d

echo "Access the challenge on localhost:5000"