# Docker Bitcoind Web
Docker Bitcoind Web bundles bitcoind and a web server into one image.
The usecase is read-only for monitoring of the node.

# Run
Using a `docker-compose.yml` is highly recommended. Define the ports for the webserver and the storage location for the bitcoin node.
``` yml
version: "3"

services:
  bitcoin:
    image: herrj/docker-bitcoin-server:latest
    ports:
      - "8080:8080"
    container_name: docker-bitcoin-server
    volumes:
      - "{on-device-storage-location}:/bitcoin/.bitcoin"
```

# Docker Hub
See the image details here: https://hub.docker.com/repository/docker/herrj/docker-bitcoin-server/general

# Build
Before building the image, you need to build the frontend separateley. In the directory `dockerbitcoinfrontend` run
``` bash
flutter build web
```

Build the docker image with buildx. Supported platforms for cross-compiling are x86_64 and aarch64
``` bash
docker buildx build -t bitcoin-web .
```

# Dev
When using Chrome as a Flatpak, you can run the UI with `CHROME_EXECUTABLE=/var/lib/flatpak/exports/bin/com.google.Chrome flutter run`