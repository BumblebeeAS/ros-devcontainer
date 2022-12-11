group "build" {
  targets = ["simulator-index", "ros-index", "humble_dev", "melodic_dev", "noetic_dev", "simulator-vrx", "simulator-uuv"]
}

target "docker-xserver" {
  context = "./docker-xserver"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/xserver:latest"]
}
target "simulator-index" {
  context = "./simulator-index"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/simulator-index:latest"]
}
target "ros-index" {
  context = "./ros-index"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/ros-index:latest"]
}

target "melodic_dev" {
  context = "./"
  dockerfile = "Dockerfile.melodic"
  tags = ["ngxingyu/ros-devcontainer:melodic-desktop"]
}
target "noetic_dev" {
  context = "./"
  dockerfile = "Dockerfile.noetic"
  tags = ["ngxingyu/ros-devcontainer:noetic-desktop"]
}
target "humble_dev" {
  context = "./"
  dockerfile = "Dockerfile.humble"
  tags = ["ngxingyu/ros-devcontainer:humble-desktop"]
}
target "simulator-vrx" {
  context = "./simulators/simulator-vrx"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/simulator_vrx:latest"]
}
target "simulator-uuv" {
  context = "./simulators/simulator-uuv"
  dockerfile = "Dockerfile"
  tags = ["ngxingyu/simulator_uuv:latest"]
}