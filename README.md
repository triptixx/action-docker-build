# action-docker-build
A plugin for [Actions CI](https://github.com/features/actions) to build and label Docker images with minimal effort

## Configuration

An example configuration of how the plugin should be configured:
```yaml
steps:
  - name: build
    uses: triptixx/action-docker-build@master
    with:
      repo: user/image-name:optional-tag
      build_args: BUILD_ARG=value, BUILD_ARG=value
```

### Available options
- `repo`          tag to this repo/repo to push to. _required_
- `path`          override working directory. _default: `.`_
- `dockerfile`    override Dockerfile location. _default: `Dockerfile`_
- `use_cache`     override to disable `--no-cache`. _default: `false`_
- `no_labels`     disable automatic image labelling. _default: `false`_
- `build_args`    additional build arguments. _optional_
- `arguments`     optional extra arguments to pass to `docker image build`. _optional_
- `make`          provides MAKEFLAGS=-j$(nproc) as a build-argument. _optional_
- `rm`            a flag to immediately `docker image rm` the built image. _optional_
- `squash`        squash the built image into one layer. _optional_
