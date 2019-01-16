# This TF file deploys an nginx docker container on specified docker host

# Connect to docker host
provider "docker" {
  # host = "tcp://localhost:2376"
  host = "unix:///var/run/docker.sock"
}

# Pick the docker image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx-server" {
  name = "nginx-server"
  image = "${docker_image.nginx.latest}"
  ports {
    internal = 80
    external = 80
  }

}
