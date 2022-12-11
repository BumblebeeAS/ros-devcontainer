ROS dev container for VSCode
----------------------------
Packed with:
- Preconfigured docker image for ROS development.
- Browser accessible X11 server to display gazebo, rviz, rqt (runs on Windows/Mac).
- Tasks definition to run catkin_make, roscore, rviz commands.
- Preconfigured code completion for C++, Python, XML (package.xml, launchfiles, URDF, SDF).
- Preconfigured simulation environments (Flatland, TurtleBot3, ARIAC, Virtual RobotX, UUV).
<!-- - Bonus: WebIDE (Theia) with preconfigured C++, Python, XML completion. -->

## Adding a new sim:
- the dockwater repo contains some useful Dockerfiles that can be used as a base image for the other containers. 
### To insert a new simulation:
  1. Add a folder under simulators containing the docker image of the simulation
  2. Add the image to the `index.yaml` file under `simulator-index`

### To build/run the ros-devcontainer:
  - if you use the experimental features of docker, you can try running `docker buildx bake build` to build all required images.
    - `xserver`: supports the display of the desktop novnc environment at localhost:3000 (default port)
    - `simulator-index`: tool to select simulator from `index.yaml` and modify the `docker-compose.yml` launch file.
    - `ros-index`: tool to select the desired ros version from `index.yaml` and modify the `docker-compose.yml` launch file
    - `noetic_dev` or `melodic_dev` etc: contains the ros environment for the development container. Contains useful tools and should contain all packages that we might require.
    - `uuv_simulator`
  - Alternatively, just build or pull all images in the termminal or with some script.
  - Specify the workspace you want to bind to the workspace container by changing the volume under workspace in `docker-compose`. Also configure any settings you want within `docker-compose`
  - Run `docker-compose up` to launch the `xserver`, `simulation` container and the ros workspace container. Ensure the `DISPLAY` env variable is set correctly. You should be able to see any guis by visiting `localhost:3000`.
  - In a new shell, run `./join.bash <container_name>` e.g. `./join.bash ros-devcontainer-workspace-1` to start a shell in the container.


VSCode and devcontainer running on Mac:
![screenshot](https://user-images.githubusercontent.com/18067/58605055-8dc84980-82d1-11e9-8ee5-dc969fcb2ae1.png)

<!-- WebIDE (Theia) opened from the local browser while devcontainer is running on the remote server:
![screenshot-theia](https://user-images.githubusercontent.com/18067/59972289-58a8d180-95c7-11e9-86fd-7d271684e8b3.PNG) -->

How to select simulation environment
-------------------------------------
You can run preconfigured simulation environment as a docker sidecar container.

Enter following command to select the simulator:
```shell
$ ./select-simulator.sh
```

Preconfigured simulation environment currently includes: Flatland, TurtleBot3, ARIAC, Virtual RobotX, UUV.

<!-- See the following index for list of current simulators:

https://github.com/devrt/simulator-index/blob/master/index.yaml -->

<!-- If you want any other simulator, let us know by submitting the issue:

https://github.com/devrt/simulator-index/issues -->


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

Included components are distributed under each different licenses:
- Theia IDE: EPL or GPL
- Jupyter notebook: BSD