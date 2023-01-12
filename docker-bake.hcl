group "build" {
  targets = ["ros-index", "select-index", "noetic_dev", "simulator-vrx", "simulator-uuv"]
}

target "docker-xserver" {
  context = "./docker-xserver"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/xserver:latest"]
}
target "ros-index" {
  context = "./ros-index"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/ros-index:latest", "ros-index:latest"]
}
target "select-index" {
  context = "./select-index"
  dockerfile = "Dockerfile"
  tags = ["select-index:latest", "select-index:latest"]
}

target "melodic_dev" {
  context = ""
  dockerfile = "./devcontainers/melodic/Dockerfile"
  tags = ["ngxingyu/ros-devcontainer:melodic-dev", "ros-devcontainer:melodic-dev"]
}
target "noetic_dev" {
  context = ""
  dockerfile = "./devcontainers/noetic/Dockerfile"
  tags = ["ngxingyu/ros-devcontainer:noetic-dev", "ros-devcontainer:noetic-dev"]
}
target "humble_dev" {
  context = ""
  dockerfile = "./devcontainers/humble/Dockerfile"
  tags = ["ngxingyu/ros-devcontainer:humble-dev", "ros-devcontainer:humble-dev"]
}
target "melodic_base" {
  context = ""
  dockerfile = "./devcontainers/melodic/Dockerfile.base"
  tags = ["ngxingyu/ros-devcontainer:melodic-base", "ros-devcontainer:melodic-base"]
}
target "noetic_base" {
  context = ""
  dockerfile = "./devcontainers/noetic/Dockerfile.base"
  tags = ["ngxingyu/ros-devcontainer:noetic-base", "ros-devcontainer:noetic-base"]
}
target "humble_base" {
  context = ""
  dockerfile = "./devcontainers/humble/Dockerfile.base"
  tags = ["ngxingyu/ros-devcontainer:humble-base", "ros-devcontainer:humble-base"]
}
target "simulator-vrx" {
  context = "./simulators/simulator-vrx"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/simulator_vrx:latest", "simulator_vrx:latest"]
}
target "simulator-uuv" {
  context = "./simulators/simulator-uuv"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/simulator_uuv:latest", "simulator_uuv:latest"]
}
