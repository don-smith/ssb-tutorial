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


# Development notes

To get on the command line in the container:

```sh
docker exec -it ssbtutorial_pub_1 /bin/bash
```

On the command line in the container (for example):

```sh
node --inspect=9119 --debug-brk ./bin.js whoami --host pub --port 8118
```

The host/port combinations are:

| Host  | Listening | Debugging |
|-------|-----------|-----------|
| pub   | 8118      | 9119      |
| user1 | 8228      | 9229      |
| user2 | 8338      | 9339      |

Change `whoami` to any available command. Use `-h` to see a list of commands.
