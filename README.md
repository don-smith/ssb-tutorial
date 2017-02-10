# Secure Scuttlebutt Tutorial

This is a hands-on walk-through, accompanied by some explanatory narrative, for people interested in becoming familiar with the _Scuttleverse_: [Secure Scuttlebutt](http://scuttlebot.io/more/protocols/secure-scuttlebutt.html), the [Scuttlebot](http://scuttlebot.io), [Patchbay](https://github.com/ssbc/patchbay), [Patchwork](https://ssbc.github.io/patchwork/), [ssb-git](https://git.scuttlebot.io/%25n92DiQh7ietE%2BR%2BX%2FI403LQoyf2DtR3WQfCkDKlheQU%3D.sha256) and many of the [associated packages](https://github.com/ssbc).

## Preparation

This tutorial uses [Docker](https://www.docker.com) so we can easily setup our laboratory with few clients on a single machine easily. You don't need to have previous experience with Docker - detailed steps and explanations are provided. If you don't already have Docker installed, you can [get Docker here](https://docs.docker.com/engine/getstarted/step_one/#step-1-get-docker). You also need to [install Docker Compose](https://docs.docker.com/compose/install/) if you haven't already.

These two commands (run separately) should not give you unexpected results:

```sh
docker version
docker-compose version
```

## Setup

```sh
git clone [this repo]
cd ssb-tutorial
docker-compose up
```

That last command will take some time while the 3 environments are built. After they are built, the Scuttlebot service will be running on each of them.


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
