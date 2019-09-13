# action-docker-build
A action CI plugin for building and labelling Docker images

A plugin for [Drone CI](https://github.com/drone/drone) to build and label Docker images with minimal effort

## Supported tags and respective `Dockerfile` links

`latest` - [(Dockerfile)](https://github.com/spritsail/drone-docker-build/blob/master/Dockerfile)

## Configuration

An example configuration of how the plugin should be configured:
```yaml
pipeline:
  build:
    image: spritsail/docker-build
    volumes: [ '/var/run/docker.sock:/var/run/docker.sock' ]
    repo: user/image-name:optional-tag
    build_args:
      - BUILD_ARG=value
```

### Available options
- `repo`          tag to this repo/repo to push to. _required_
- `path`          override working directory. _default: `.`_
- `dockerfile`    override Dockerfile location. _default: `Dockerfile`_
- `use_cache`     override to disable `--no-cache`. _default: `false`_
- `no_labels`     disable automatic image labelling. _default: `false`_
- `build_args`    additional build arguments. _optional_
- `arguments`     optional extra arguments to pass to `docker build`. _optional_
- `make`          provides MAKEFLAGS=-j$(nproc) as a build-argument
- `rm`            a flag to immediately `docker rm` the built image. _optional_
- `squash`        squash the built image into one layer. _optional_
