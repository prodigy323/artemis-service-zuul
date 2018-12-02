#!/usr/bin/env bash

PRJ_NAME=$(basename `pwd`)
PORT=8901
PART=(${PRJ_NAME//-/ })
IMG_NAME=${PART[2]}

mvn -DskipTests clean package

## check for and remove any existing docker images
#if [[ -n $(docker ps | grep ${PRJ_NAME}) ]]
#then
#    echo "Found a running container...removing"
#    docker stop $(docker ps | grep ${PRJ_NAME} | awk '{print $1}')
#else
#    echo "No running containers"
#fi
#
#if [[ -n $(docker ps -a | grep ${PRJ_NAME}) ]]
#then
#    echo "Found a container...removing"
#    docker rm $(docker ps -a | grep ${PRJ_NAME} | awk '{print $1}')
#else
#    echo "No containers"
#fi
#
#if [[ -n $(docker images | grep ${PRJ_NAME}) ]]
#then
#    echo "Found an image...removing"
#    docker rmi $(docker images | grep ${PRJ_NAME} | awk '{print $3}')
#else
#    echo "No images"
#fi
#
## check for and remove any rogue images
#if [[ -n $(docker images | grep '<none>') ]]
#then
#    echo "Found rogue images...removing"
#    docker rmi $(docker images -f "dangling=true" -q)
#else
#    echo "No rogue images"
#fi
#
## build new docker image
#docker build --build-arg JAR_FILE=target/${PRJ_NAME}-0.0.1-SNAPSHOT.jar -t ${PRJ_NAME}:latest .
#
## run the container
#docker run -d --name ${IMG_NAME} -p ${PORT}:${PORT} ${PRJ_NAME}:latest

# check if process is running
if [[ -n $(ps -ef | grep "${PRJ_NAME}-0.0.1-SNAPSHOT" | grep -v grep) ]]
then
    PID=$(ps -ef | grep "${PRJ_NAME}-0.0.1-SNAPSHOT" | grep -v grep | awk '{print $2}')
    kill -9 ${PID}
    if [[ -f ~/dev/logs/${PRJ_NAME}.pid ]]
    then
        rm ~/dev/logs/${PRJ_NAME}.pid
    fi
fi

# execute local jar
java -jar target/${PRJ_NAME}-0.0.1-SNAPSHOT.jar > ~/dev/logs/${PRJ_NAME}.log 2>&1 &
echo $! > ~/dev/logs/${PRJ_NAME}.pid