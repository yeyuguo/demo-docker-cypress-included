#!/usr/bin/env bash
# pass DISPLAY variable pointing at the host's X11 server
# like XQuartz
# read https://sourabhbajaj.com/blog/2017/02/07/gui-applications-docker-mac/

IP=$(ipconfig getifaddr en0)
# this assumes that X11 server allows connections over the network
# after we execute "/usr/X11/bin/xhost + $IP"
DISPLAY=$IP:0

# explanation of the "docker run" command line arguments
#
#  -it          = interactive terminal
#  -v $PWD:/e2e = map current folder to /e2e inside the container
#  -v /tmp/.X11-unix:/tmp/.X11-unix = map X11 socket file to communicate
#  -w /e2e      = set working directy to /e2e
#  -e DISPLAY   = pass environment variable DISPLAY to the container
#  --entrypoint cypress = run "cypress" command
#     with arguments AFTER Docker image name
#     in our case they are "--project ." to point globally installed Cypress
#     at the current working directory /e2e inside the container


# docker run -it \
#   -v $PWD:/e2e \
#   -v /tmp/.X11-unix:/tmp/.X11-unix \
#   -w /e2e \
#   -e DISPLAY \
#   --entrypoint cypress \
#   cypress/included:3.4.0 open --project .


# docker run -it \
#   --network host \
#   -v $PWD:/e2e \
#   -v /tmp/.X11-unix:/tmp/.X11-unix \
#   -w /e2e \
#   -e DISPLAY \
#   --entrypoint '' \
#   cypress/included:3.4.0 \
#   npx cypress open

# 正确能执行 npm install && xhost && ./cy-open.sh
docker run -it --rm \
    --network host \
    -v ~/.Xauthority:/root/.Xauthority:ro \
    -e DISPLAY \
    -v $PWD:/e2e \
    -w /e2e \
    --entrypoint '' \
    cypress/included:6.2.1 \
    npx cypress open
    # npx cypress cache clear && npx cypress open




# 报错解决办法: (Cypress:15): Gtk-WARNING **: cannot open display: 192.168.253.2:0
# https://stackoverflow.com/questions/59514234/viewing-the-interactive-cypress-test-runner-in-docker-on-linux