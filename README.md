ROS dev container
----------------------------
Packed with:
- Preconfigured docker image for ROS development.
- Browser accessible X11 server to display gazebo, rviz, rqt (runs on Windows/Mac).
- Tasks definition to run catkin_make, roscore, rviz commands.
- Preconfigured code completion for C++, Python, XML (package.xml, launchfiles, URDF, SDF).
- Preconfigured simulation environments (Virtual RobotX, UUV).

### Structure of repo
```
|__devcontainers # contains the dockerfiles for the different ros distros
|  |__humble
|     |__Dockerfile.base # version of original dockwater without gazebo dependencies
|     |__Dockerfile      # container with additional packages for easier development
|__simulators # contains the dockerfiles for the different simulation environments
|  |__simulator-uuv           # uuv_simulator (noetic + gazebo 11)
|  |__simulator-vrx           # vrx (noetic + gazebo 11)
|  |__simulator-vrx-gazebosim # vrx (humble + gazebo garden)
|__docker-compose.yml # docker-compose file to launch the containers.
|__select-env.sh      # simple cli tool to select the simulation environment (devcontainer + simulator) and update `docker-compose.yml`
|__join.bash      # Use this to attach a bash shell to an existing container. Typical usage: ./join.bash <container_name>
|__build.sh       # Use this to build the docker images. You can also use `docker buildx bake build` to build all images.
```

## Adding a new sim:
- the dockwater repo contains some useful Dockerfiles that can be used as a base image for the other containers.
### To insert a new simulation:
  1. Add a folder under simulators containing the docker image of the simulation
  2. Add the image to the `simulator-index.yaml` file under `select-index` and rebuild `select-index`

### To build/run the ros-devcontainer:
  - Run `select.sh` to select some prebuilt images to use for the ros container and the simulation container.
  - To manually build any of the images for testing,
    - uncomment the relevant lines within `build.sh`
      - `select-index`: tool to select ros container and simulation container from `index.yaml` and modify the `docker-compose.yml` launch file.
      - `noetic-dev` or `melodic-dev` etc: contains the ros environment for the development container. Contains useful tools and should contain all packages that we might require for development.
      - `uuv_simulator` simulation image
      - `vrx` simulation image
      - `vrx-gazebosim` simulation image
    - You will need to start the ssh-agent and add your ssh-key to allow docker to clone the required private repos.
    - update `docker-compose.yml` to point to the image you built

<code>
eval $(ssh-agent -s)

ssh-add ~/.ssh/YOUR_PRIVATE_KEY # add key which can access all above repositories

build.sh
</code>
  - Select the simulation environment and the ros version using `./select-env.sh`
  - Specify any settings or volumes you want to bind to the workspace container by changing the docker volume under workspace in `docker-compose.yml`. By default, the entire workspace will be bind-mounted to a folder corresponding to the ros container image name under `.volumes`.
  - Run `docker-compose pull && docker-compose up` to launch the `xserver`, `simulation` container and the ros workspace container. Ensure your `DISPLAY` env variable is set correctly. You should be able to view the guis by visiting `localhost:3000`.
  - In a new shell, run `./join.bash <container_name>` e.g. `./join.bash ros-devcontainer-workspace-1` to start a shell in the container. Alternatively, use vscode to attach the container that you want to work on.


VSCode and devcontainer running on Mac:
![screenshot](https://user-images.githubusercontent.com/18067/58605055-8dc84980-82d1-11e9-8ee5-dc969fcb2ae1.png)


How to use this dev container with VSCode
-----------------------------------------
First, you have to install VSCode and Docker for Windows/Mac:
- https://code.visualstudio.com/
- https://docs.docker.com/docker-for-mac/
- https://docs.docker.com/docker-for-windows/

After you installed required softwares:

1. Install ["Remote Development" extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) on your VSCode.
2. Clone this repository by using git command.
3. Click on the quick actions status bar item (green icon) in the lower left corner of the VSCode.
4. Select "Remote-Containers: Open Folder in Container..." from the command list that appears, and open the root folder of the project you just cloned.
5. You need to wait a while for container to come up (only required once).

For detailed instructions, see:
https://code.visualstudio.com/docs/remote/containers

If you are behind the proxy
-----------------------------

Please apply following two settings, if you are using your PC behind the proxy.

1. Proxy setting for the Docker server.

Click Docker Desktop task bar icon > Select `preference` menu item. You will see the following options:

![docker-proxy-settings](https://user-images.githubusercontent.com/18067/59744551-c4302d80-92ad-11e9-9b20-cc873a53a8bb.png)

In most cases, `System proxy` option will work. But if you have problem downloading the docker images, please try `Manual proxy configuration` option.

2. Proxy setting for the devcontainer.

This setting will enable you to use the `apt-get` or the other network commands inside the devcontainer.

First, open `.env.sample` file under the root folder of the cloned project.
Edit the settings according to your environment.
Save the file as name `.env`.

Next, open `docker-compose.yml` file under the root folder of the cloned project and uncomment the following lines:
```yaml
  workspace:
    env_file:
      - .env
```

How to reset or update the devcontainer
---------------------------------------

If you want to reset the devcontainer. Please close vscode and enter the following command under the folder of the cloned project:
```shell
$ docker-compose down
```

If you want to update the environment to the most recent version. Please enter the following commands under the folder of the cloned project:
```shell
$ git pull origin master
$ docker-compose pull
```

Please be noticed that the `docker-compose down` command will reset your environment including installed `.deb` packages. However, if you write `package.xml` files correctly, you can reinstall all the depending packages by entering the following two commands:
```shell
$ rosdep update
$ rosdep install --from-paths src --ignore-src -r -y
```

How to open X11 server screen
-----------------------------

1. Wait for the container to start.
2. Open http://localhost:3000/ using your favorite browser.

If you are using Docker Toolbox, open the following URL instead:

http://192.168.99.100:3000/

If you want browser screen to be integrated with VS Code, use [Browser Preview for VS Code extension](https://marketplace.visualstudio.com/items?itemName=auchenberg.vscode-browser-preview).

Created by
----------
Yosuke Matsusaka (MID Academic Promotions, Inc.)

License
-------
Code in this repository (Dockerfile, utility scripts, etc) is distributed under Apache 2.0 license.