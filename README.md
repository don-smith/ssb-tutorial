# Secure Scuttlebutt Tutorial

This is a hands-on walk-through, accompanied by some explanatory narrative, for people interested in becoming familiar with the _Scuttleverse_: [Secure Scuttlebutt](http://scuttlebot.io/more/protocols/secure-scuttlebutt.html), the [Scuttlebot](http://scuttlebot.io), [Patchbay](https://github.com/ssbc/patchbay), [Patchwork](https://ssbc.github.io/patchwork/), [ssb-git](https://git.scuttlebot.io/%25n92DiQh7ietE%2BR%2BX%2FI403LQoyf2DtR3WQfCkDKlheQU%3D.sha256) and many of the [associated packages](https://github.com/ssbc) from a developer perspective.

I'm writing this tutorial as I enter my Scuttleverse learning journey in hopes it will make it easier for others to understand how the pieces work together.


## Preparation

This tutorial uses [Docker](https://www.docker.com) so we can easily setup our laboratory with a few clients on a single machine easily. You don't need to have previous experience with Docker - detailed steps and explanations are provided. If you don't already have Docker installed, you can [get Docker here](https://docs.docker.com/engine/getstarted/step_one/#step-1-get-docker). You also need to [install Docker Compose](https://docs.docker.com/compose/install/) if you haven't already.

Once you're set up, these two commands (run separately) should not give you unexpected results:

```sh
docker version
docker-compose version
```

## Setup

```sh
git clone https://github.com/don-smith/ssb-tutorial.git
cd ssb-tutorial
docker-compose up
```

That last command will take some time while the image is downloaded and the 3 node containers are built. Once finished, the Scuttlebot service will be running on each of them. Later, _not now_, you can stop the containers using `Ctrl-c`.

Before they can begin communicating with each other, they must be directly or indirectly connected. And to connect them, we need their IDs.


## Saving the public key IDs

The nodes should still be running from the instructions above. In a different terminal window, navigate to the `ssb-tutorial` repo folder. First, let's get on the command line inside the `pub` node.

```sh
docker exec -it pub /bin/bash
```

Now your prompt should be `root@pub:/scuttlebot# ` which means you're in the `/scuttlebot` folder inside the `pub` container. There is also a `/shared` folder that maps to the `/scuttlebot/shared` folder so we can share files between containers and our computer. These commands will create a text file containing the ID of `pub` and `exit` the container.

```sh
./bin.js whoami $SSB_CFG > /shared/pub/id.txt
exit
```

The `$SSB_CFG` environment variable is only in place to make it easier to run scuttlebot commands in the environment of this tutorial. If you're interested, see `docker-compose.yml` (or run `echo $SSB_CFG` within a container) to see its values.

Now let's do the same thing for the `user1` and `user2` containers. Note: the port number are different for each one.

```sh
# For user1
docker exec -it user1 /bin/bash
./bin.js whoami $SSB_CFG > /shared/user1/id.txt
exit
```
and

```sh
# For user2
docker exec -it user2 /bin/bash
./bin.js whoami $SSB_CFG > /shared/user2/id.txt
exit
```

Now we have the IDs of each of the containers.

_More instructions forthcoming ..._



# Unplaced tutorial notes

I'll end up putting this content somewhere. For now it's here.


## Debugging the server process

By default the scuttlebot server running in each container is not running in debug mode. To enable service debugging, set one or more of these environment variables to `debug` as you're running `docker-compose up`.

| Container | Environment variable |
|-----------| ---------------------|
| pub       | PUB_ACTION           |
| user1     | USER1_ACTION         |
| user2     | USER2_ACTION         |

For example, to run only the `pub` container's service in debug mode and `user1` and `user2` normally:

```sh
PUB_ACTION=debug docker-compose up
```

And to start both `pub` and `user1` services in debug mode:

```sh
PUB_ACTION=debug USER1_ACTION=debug docker-compose up
```

A `chrome-devtools://` URL will be printed to the terminal for each container running in debug mode. Copy and paste this URL into Google Chrome. The debugger will be set on the first line of code. You'll need to "continue" the debugger for the server to run normally.

If you're curious how this is done, check out the value of the `command` setting for each container in `docker-compose.yml`. It executes either `run-server.sh` (the default) or `debug-server.sh` based on the availability of the environment variable.


## Scuttlebot client commands

To issue commands on the command line, you need decide which environment/container you wish to run on, and then get on its command line. To see a list of containers and access the command line of one of them:

```sh
docker ps -a # should see pub, user1 and user2
docker exec -it pub /bin/bash
```

Once on the command line you can run scuttlebot client commands (for example):

```sh
# Without debugging
./bin.js whoami --port 8118

# With debugging
node --inspect=9119 --debug-brk ./bin.js whoami --port 8118
```

The available host/port combinations are:

| Host  | Listening | Debugging |
|-------|-----------|-----------|
| pub   | 8118      | 9119      |
| user1 | 8228      | 9229      |
| user2 | 8338      | 9339      |

In the example above, the `whoami` command can be changed to any available command. Use the `-h` command to see a list of available commands.
