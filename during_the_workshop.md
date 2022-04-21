# Workshop Instructions

## Part 1 - Running a Docker container

### Hello, World

We're going to start simple by running a single docker container.

```bash
$ docker run hello-world
```

If successful you should see something like this, which helpfully explains exactly what docker has done.
![Hello, World!](./Images/workshop-01-docker-hello-world.jpg)

If you are having problems check these two things:

1. That Docker Desktop is running
2. That you are running your docker commands with elevated permissions.

We can see some evidence for the steps that docker has taken to print this message using the following commands:

```bash
# List the images that docker currently has in its local cache.
# It should only display the 'hello-world' image.
$ docker image list

# List all containers currently running.
# It should be empty.
$ docker container list

# List all containers.
# It should show that your hello-world container exited recently.
$ docker container list --all
```

You'll notice that Docker has assigned a randomly-generated name to the container (the last column in the above output). This is the default behaviour for docker run unless you specify a container name using the `--name` option.

### Hello, nginx

Now let's try something slightly more complicated. Running a common web server (nginx) in a container:

```bash
$ docker run --detach --publish 8080:80 nginx
```

In the above command, we're asking Docker to create and run a new container based on the nginx image. Docker first looks for an image tagged "nginx" on your local machine. If none exists, it will pull an appropriate image from [Docker Hub](https://hub.docker.com/).

Here we've also used the `--detach` option to run it in the background. We've also declared that port 80 on the container should be bound, or published, to port 8080 on your host machine (note the slightly confusing syntax for declaring the port mapping, i.e. host:container). Now point your browser at <http://localhost:8080/> and you should see the nginx start page.

When containers run in the background, you can view their output using `docker logs <container_name>` (where `<container_name>` is the name of the container). Finally, let's stop the container and remove it:

```bash
$ docker container stop <container_name>
$ docker container rm <container_name>
```

## Part 2 - Write a Dockerfile

Now we've seen docker working, let us build a Dockerfile. We'll use an example from the reading material. In a new directory, create a file called `Dockerfile` with the following content.

```dockerfile
FROM alpine
ENTRYPOINT ["echo", "Hello World"]
```

Then build and run it with the following command. The `.` is important; it's the build context and refers to the current directory.

```bash
$ docker build --tag hello-world .
$ docker run hello-world
```

You should see something like this:

```
$ docker build --tag hello-world .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM alpine
latest: Pulling from library/alpine
df20fa9351a1: Pull complete
Digest: sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321
Status: Downloaded newer image for alpine:latest
 ---> a24bb4013296
Step 2/2 : ENTRYPOINT ["echo", "hello world"]
 ---> Running in ee94d1da8d4b
Removing intermediate container ee94d1da8d4b
 ---> 9cfaf67c8c45
Successfully built 9cfaf67c8c45
Successfully tagged hello-world:latest
$ docker run hello-world
hello world
```

You should also be able to see your image in the output of `docker image list`:

![docker image list](./Images/workshop-02-docker-image-list.jpg)

Let's add another tag to our image.

```bash
$ docker tag hello-world hello-world:v1
```

Now you should see something more like this:

![docker image list](./Images/workshop-03-docker-image-list.jpg)

Note: while we have a new entry the image ID is the same. Both the `v1` and `latest` tag are pointing at the same image.

Now change your Dockerfile to make it print a new message and build it again. You should see that the `latest` tag now has a different image ID. This should emphasise that even though your Dockerfile is mutable, the images produced are not.

## Part 3: Publish an Image

To see how Docker image registries work in practice, let's push the hello-world image we created earlier to Docker Hub.

First you'll need to create an account on Docker Hub, if you don't have one already. You can create one [here](https://hub.docker.com/signup).

Now you need to give the Docker CLI your login credentials so it can pull and push images to your account. From a terminal, run:

```bash
$ docker login
```

and enter your username and password when prompted. If successful, you should see a "Login Succeeded" message printed to the terminal.

Before you can push the hello-world image to Docker Hub, you need to associate it with your account by prefixing the image name with your account username. You can do this by creating a new image tag that points to the existing image:

```bash
$ docker tag hello-world <your_username>/hello-world
```

(Make sure you replace <your_username> with your Docker Hub username!)

Running `docker image ls` should now show two entries, hello-world and <your_username>/hello-world that both have the same image ID.

We can now push that image to Docker Hub:

```bash
$ docker push <your_username>/hello-world
```

Once the image has been pushed, the command will print out the unique digest (hash) for that image.

Visit your Docker Hub account in a web browser and you should see a new public repository has been created for your hello-world image. Click on that entry to see more details about the repository, including available tags.

You could create additional builds of the hello-world image and tag them with version numbers, then upload those to the same repository, e.g.

```bash
$ docker build --tag <your_username>/hello-world:1.0 .
$ docker push <your_username>/hello-world:1.0
```

## Part 4: Dockerise Chimera

> :warning: **M1 Mac users** The cliapp is built for x86-64. To run it on an ARM machine pass `--platform linux/amd64` to the docker build command. You can also try using [gitpod](gitpod.io#https://github.com/CorndelWithSoftwire/DevOps-Course-Workshop-Module-05).

Now for something more complicated. In Module 04 we worked with a legacy application called the Chimera Reporting Server. In the remainder of this exercise we are going to convert that application to using Docker. This process is sometimes called "dockerising" or "containerising" an application.

Fortunately, we already have a Dockerfile for running the webapp and a half-written Dockerfile for running the CLI. You can find these in [./dockerfiles](./dockerfiles). Clone this repository to get a local copy of that folder.

This application will run slightly differently to the previous module. The `webapp` container will still serve a simple website, but the `cliapp` container behaves slightly differently.

### 01: Build the webapp

You will need to build each image separately using `docker build`.

First, try building an image from Dockerfile.webapp.

- Use the `-f` option of `docker build` to specify a filename. If you don't, then it will look for a file called "Dockerfile".
- Use the `--tag` or `-t` option to set a "tag". This will label the image with whatever name you choose, so that you can easily refer to the image in the future.

### 02: Finish and build the cliapp Dockerfile

Next, try building the image for the CLI app, but **this will require completing the Dockerfile**. The aim is to have a container that runs the provided [run.sh](./dockerfiles/run.sh) file. If you are on Windows and you create a `run.sh` file yourself (instead of using git), make sure to create it with LF line endings so it is compatible with the Linux container.

Scroll down this [documentation page](https://docs.docker.com/engine/reference/builder) for how to use the different Dockerfile commands. Try building the image now and after each change to check if there are any issues.

<details markdown="1"><summary>Hints</summary>

1. The Dockerfile.cliapp currently fails to build! If you look at the error message, it is failing to run the `curl` command because it doesn't recognise it. You need to install `curl`. Do this in the same way that `jq` is being installed (see the `RUN apt-get install ...` line).
1. The purpose of the image is to run the `run.sh` file in the dockerfiles folder. To do this, it needs a copy of the file stored inside the image. So add an appropriate `COPY` command to your Dockerfile.
1. After copying the file in, let's configure it as executable. On Linux, you do this by running a shell command e.g. `chmod +x ./my-file.sh`. Add a `RUN` command to the Dockerfile that makes the run.sh file executable.
1. At the moment, nothing happens if you build and run a container based on this Dockerfile. You need to tell it what to do when starting the container. Add an `ENTRYPOINT` command that executes the `run.sh` file.

<details markdown="1"><summary>Click here for answers</summary>

1. `RUN apt-get install -y curl`
   - This must be done before the `RUN curl ...` line.
   - Or better yet, modify the existing line for jq instead: `RUN apt-get install -y jq curl`. This installs both jq and curl.
1. `COPY ./run.sh ./run.sh`
   - This takes the run.sh file from the "build context" (the folder on your machine where the build is happening) and saves it as run.sh in the current WORKDIR (a location within the image).
   - If you build the image by running `docker build -f dockerfiles/Dockerfile.cliapp .` from the parent folder, then your build context is that parent folder. So your COPY command should be `COPY ./dockerfiles/run.sh ./run.sh` in order to point to the run.sh file correctly.
1. `RUN chmod +x ./run.sh`
   - This should go directly after the COPY command
1. `ENTRYPOINT [ "./run.sh" ]`

</details>

</details>

### 03: Run the containers

Running each container with `docker run` is fairly straightforward. However, the containers will need a way to communicate; we suggest you mount a [**named volume**](https://docs.docker.com/storage/volumes/). Use the same volume for both containers so that the "webapp" container can access files created by the "cliapp" container.

<details markdown="1"><summary>Click here for help with the --mount option</summary>

The `--mount` and `--volume` arguments have the same functionality for creating volumes but with different syntax. The syntax for `--mount` is more verbose, but that means it is more explicit and easier to understand.

You need to provide `--mount` with three things:

- The "type" of mount - in this case we want a "volume".
- The "source" - in the case of a volume, this means the name of the volume.
- The "destination" - the folder inside the container where the volume will be accessible. This will need to match where the CLI app is saving files and where the web app is reading from.

So your command will look something like the following but with the correct values filled in:

```
docker run --mount type=volume,source=choose-a-name,destination=/path/to/folder
```

</details>

You'll also need to `--publish` a port when running the web app container in order to view the website. This means forwarding traffic from a port on your computer to a port on the container.

Visit localhost:\<port-number>/all_day in a browser to see the webapp displaying data processed by cliapp.

Note for those using Git for Windows: it automatically expands any absolute paths it detects in your command. Use a double slash at the start to prevent this e.g. `//dont/expand/me`

### 04: Refactor and improve!

The Dockerfiles and bash script we've provided you aren't as good as they could be. Spend a little time trying to improve them before moving onto the next exercise.

To get started, take a look at Docker's official [best practices guide for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

## Part 5: Docker Compose

In the previous section we ended up constructing some reasonably long command line statements to build, configure and run our containers. This is error prone and doesn't scale well; consider how fiddly it was with just two containers!

Fortunately there are tools that can help us automate these processes. We are going to use one called Docker Compose. This will be already installed if you have Docker Desktop on Windows or Mac (If you're on Linux you can find installation instructions [here](https://docs.docker.com/compose/install/)).

To use docker compose you create a YAML file called `docker-compose.yml` that describes the **services** you want; how to build them; and what volumes, ports and other settings you want to run them with. (For the purposes of this exercise you can consider services to be synonymous with containers.)

When you have completed your YAML file you build and run all your containers with a single command: `docker compose up`.

You may find the following reference material helpful:

- [Compose file reference](https://docs.docker.com/compose/compose-file/)
- More specifically:
  - You need a [build](https://docs.docker.com/compose/compose-file/compose-file-v3/#build) section for each service where you want to build the image yourself, which you do for both the webapp and cliapp.
  - You need the cliapp and webapp to share a [volume](https://docs.docker.com/compose/compose-file/compose-file-v3/#volume-configuration-reference)
  - You need to publish a [port](https://docs.docker.com/compose/compose-file/compose-file-v3/#ports) for the webapp to be accessible on your host machine.

We've provided you with a _very_ minimal docker compose file below. Using the reference material above and your answers to part 4 complete the file so you that you can reproduce the same result as part 4 with only a single `docker compose up` command?

```yaml
# Copy this into a file called `docker-compose.yml`
version: "3"

services:
  cliapp:
    TODO: COMPLETE THIS
  webapp:
    TODO: COMPLETE THIS

volumes:
  TODO: COMPLETE THIS
```

## Part 6: Redis

In this part of the workshop we will demonstrate how easy it is to add new functionality using containers. Chimera can be configured to use [Redis](https://redis.io/topics/introduction), an in-memory data store, as an alternative to the data folder in the shared volume. (Redis is more sophisticated than a basic file system; we might want to use it as a remote cache, or take advantage of its message brokering features. You don't need to understand the features of Redis for the purposes of this exercise, but do read about it if you're interested.)

To do this you need to set two environment variables (`REDIS_HOST` and `REDIS_PORT`) for both the `webapp` and `cliapp`. You'll also need to update the `run.sh` file to run `cliapp` with the `-r` flag to enable redis mode. Finally, you should remove the shared data volume from `docker-compose.yml` and the Dockerfiles - you won't need it anymore!

You will need to:

- Find a Redis image on [Docker Hub](https://hub.docker.com/) and add it to your `docker-compose.yml` file as a service.
- Set `REDIS_PORT` to the default port 6379
- Set `REDIS_HOST` to the host name of the redis container
- Ensure that the `-r` flag is passed to `cliapp` on the command line.

Hint: to rebuild your containers you may need to call `docker compose` with the `--build` flag, e.g.

```bash
$ docker compose up --build
```

## Part 7: Improve the cliapp image (stretch)

The cliapp image currently generates three datasets and then exits. You need to manually run it again in order to get more recent data. Let's update it so that it runs a scheduled job instead.

First, write a crontab file which runs the `run.sh` file every five minutes (or every minute for faster testing) and redirects the output to `/var/log/cron.log`. Note that the cronjob will not run from the Dockerfile's `WORKDIR`, and make sure you've set LF line endings on the file.

<details><summary>Expand to see the cron job definition </summary>

`* * * * * /opt/chimera/bin/run.sh >> /var/log/cron.log 2>&1`  
The `>>` redirects "stdout" to append to a file and `2>&1` combines stderr (i.e. error messages) with stdout

</details>

Then update the Dockerfile to accomplish the following steps:

1. Install cron with `apt-get`.
2. Create an empty log file at `/var/log/cron.log` for the job to send its output to.
3. `COPY` the crontab file into the image.
4. Load the crontab file by running `crontab your_crontab_file`.
5. Write an `ENTRYPOINT` that starts `cron` and doesn't just exit immediately. Otherwise the container will exit immediately, without running scheduled jobs. <details><summary>Answer</summary>You can either run cron in the foreground with `cron -f` or perhaps more usefully you could print the logs with tail, if your cronjob is directing its output to a log file, e.g.: `cron && tail -f /var/log/cron.log`. This will save you having to dig into the container to debug issues</details>

You will probably see some error messages at this point (after the job has had a chance to run) that you need to address.

<details>
<summary>Expand for hints</summary>

- The `run.sh` file uses `./cliapp` but the cronjob runs from a different folder. Change it to a full file path: `/opt/chimera/bin/cliapp`
- Run this command at the start of the `ENTRYPOINT` to make environment variables available to the cronjob `printenv >> /etc/environment`. Otherwise, DATA_FOLDER or REDIS_HOST etc will not be set during the cronjob.

</details>

## Part 8: nginx (stretch)

Docker-compose lets us rearchitect applications very easily. In this part your task is to introduce [nginx](https://www.nginx.com/), a very lightweight webserver, in front of the webapp. This will give us more control over the incoming traffic.

In this case we want to introduce `nginx` and use its rewrite functionality to change the URLs used to access the map. Specifically, we want to only serve maps if the user visits an endpoint starting `/maps/dataset/`. For example, visiting `localhost:8080/maps/dataset/all_hour` should return the `all_hour` dataset.

Any requests that do not start `/maps/dataset` should result in an HTTP 404 error.

This is a stretch exercise, so we're only providing limited guidance. You should use your existing knowledge and access to [nginx documentation](https://nginx.org/en/docs/).

You will need to:

- Set up an nginx container
- Create a nginx config file and `COPY` it to the location in the container that nginx expects to find its config files
- Configure nginx as a [reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- Configure [rewrite rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/) in nginx
