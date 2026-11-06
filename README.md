# README Generator

- [README Generator](#readme-generator)
  - [Build locally](#build-locally)
  - [How to use the tool](#how-to-use-the-tool)
  - [License](#license)

`readme-generator` is a tool to simplify the creation of README for Helm Charts inside Docker images.

It is based on the [readme-generator-for-helm](https://github.com/bitnami/readme-generator-for-helm) tool by Bitnami.

It is designed to be used in CI/CD pipelines, but it can also be used locally.

## Build locally

To build the docker image locally simply run:

```shell
docker build . -t readme-generator:<version>
```

## How to use the tool

To create a README for your Helm Chart project, from the root folder run:

```shell
docker run \
  --rm  \
  -v $(pwd):/work \
  -w=/work \
  readme-generator:<version> \
  -v values.yaml \
  -r README.md
```

## License

Where not otherwise specified, everything is licensed under the [MIT License](./LICENSE).  
Please verify legal compliance if/when using this project as a whole or parts of it.

The Docker image bundles [readme-generator-for-helm](https://github.com/bitnami/readme-generator-for-helm) by Bitnami, which is licensed under the [Apache License 2.0](https://github.com/bitnami/readme-generator-for-helm/blob/main/LICENSE.txt). Its license file is shipped inside the image at `/app/LICENSE.txt`.
