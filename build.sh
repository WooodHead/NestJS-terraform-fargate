#!/bin/bash

docker build . --tag nest:latest
docker tag nest:latest 177188985094.dkr.ecr.us-east-1.amazonaws.com/example/nest:latest
docker push 177188985094.dkr.ecr.us-east-1.amazonaws.com/example/nest:latest