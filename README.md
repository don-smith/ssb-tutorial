# Secure Scuttlebutt Tutorial

This is a hands-on walk-through, accompanied by some explanatory narrative, for people interested in becoming familiar with the _Scuttleverse_: [Secure Scuttlebutt](http://scuttlebot.io/more/protocols/secure-scuttlebutt.html), the [Scuttlebot](http://scuttlebot.io), [Patchbay](https://github.com/ssbc/patchbay), [Patchwork](https://ssbc.github.io/patchwork/), [ssb-git](https://git.scuttlebot.io/%25n92DiQh7ietE%2BR%2BX%2FI403LQoyf2DtR3WQfCkDKlheQU%3D.sha256) and many of the [associated packages](https://github.com/ssbc) from a developer perspective.

I'm writing this tutorial as I enter my Scuttleverse learning journey in hopes it will make it easier for others to understand how the pieces work together.

Before we get started it's worth noting the great documentation that already exists. You should definitely use them while going through this tutorial to get more information and context.

* [Scuttlebot docs](https://ssbc.github.io/scuttlebot/) and specifically its [tutorial](https://ssbc.github.io/docs/scuttlebot/tutorial.html) and [API/CLI Reference](https://ssbc.github.io/scuttlebot/api.html).
* _more links forthcoming_


## Preparation

This tutorial uses [Docker](https://www.docker.com) so we can easily setup our laboratory with a few clients on a single machine easily. You don't need to have previous experience with Docker - detailed steps and explanations are provided. If you don't already have it installed, you can [get Docker here](https://docs.docker.com/engine/getstarted/step_one/#step-1-get-docker). You also need to [install Docker Compose](https://docs.docker.com/compose/install/) if you haven't already.

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

That last command will take some time while the image is downloaded and the 3 node containers are built. Once finished, the `sbot service` will be running on each of them. Later, _not now_, you can stop the containers using `Ctrl-c`.

Before they can begin communicating with each other, they must be directly or indirectly connected. And to connect them, we need their IDs.


## Saving the feed IDs

The nodes should still be running from the instructions above. In a different terminal window, navigate to the `ssb-tutorial` repo folder. First, let's get on the command line inside the `pub` node.

```sh
./cli-for pub

# This is just a simple script that does this:
# docker exec -it $1 /bin/bash
```

Now your prompt should be `root@pub:/scuttlebot# ` which means you're in the `/scuttlebot` folder inside the `pub` container. There is also a `/shared` folder that maps to the `/scuttlebot/shared` folder so we can share files between containers and our computer. These commands will create a text file containing the ID of `pub` and `exit` the container.

```sh
./bin.js whoami $SSB_CFG > /shared/pub/id.txt
exit
```

The `$SSB_CFG` environment variable is only in place to make it easier to run scuttlebot commands in the environment of this tutorial. If you're interested, see `docker-compose.yml` (or run `echo $SSB_CFG` within a container) to see its values.

Now let's do the same thing for the `user1` and `user2` containers.

```sh
# For user1
./cli-for user1
./bin.js whoami $SSB_CFG > /shared/user1/id.txt
exit

# For user2
./cli-for user2
./bin.js whoami $SSB_CFG > /shared/user2/id.txt
exit
```

Now we have the feed ID saved for each container.


## Following a feed

Let's have `user2` follow `user1`. On your machine (not in a container), use a text editor to copy the value of `id` in `/shared/user1/id.txt` onto your clipboard. **Tip**: if you have [`jq`](https://stedolan.github.io/jq/) and [`xclip`](https://github.com/astrand/xclip) installed, you can do this quickly without a text editor by running `./copy-id-of user1` (recommended).

An example value looks something like this:

```
@SdrtWPT0146ez9c9idvaTeWEiPKD6HHe9PTDKw/Imek=.ed25519
```

Now let's get on the command line of the `user2` container and follow `user1`. The containers should still be running. Instead of the contact feed ID value below, paste yours from your clipboard.

```sh
./cli-for user2
./bin.js publish $SSB_CFG --type contact --following \
  --contact @SdrtWPT0146ez9c9idvaTeWEiPKD6HHe9PTDKw/Imek=.ed25519
```


## Viewing a container's feed

While still on user2's command line, have a look at all available feeds.

```sh
./bin.js log $SSB_CFG
exit
```

Notice how you can see the follow post, but that's all.

You can use `feed` instead of `log` if you want to see only the feed for user2. Right now they are the same because nothing is being replicated between the peers. Let's change that.


## Posting a public message

Now we're going to publish a post as user1 in hopes it will replicate to user2.

```sh
./cli-for user1
./bin.js publish $SSB_CFG --type post --text "User1 is now online"
exit
```

Now exit user1's command line, open user2's command line, and view the log again.

```sh
exit
./cli-for user2
./bin.js log $SSB_CFG
```

:tada: you should now see user1's post in user2's logs. Replication has occurred!





_More instructions forthcoming ..._


# Unplaced tutorial notes

I'll end up putting this content somewhere sensible. For now it's here.

## Figure out how to use `sbot`

Right now I'm using `./bin.js` everywhere. This could be confusing to others who see `sbot` used throughout the docs and what they are likely to use outside of this tutorial.


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
./cli-for pub
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
