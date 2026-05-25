FROM alpine/git:2.36.3 AS source

WORKDIR /generator
RUN git clone https://github.com/bitnami-labs/readme-generator-for-helm.git

FROM node:22-alpine

RUN apk update && apk upgrade --no-cache
RUN npm update -g npm
WORKDIR /generator

COPY --from=source /generator/readme-generator-for-helm .

RUN npm install && \
    npm dedupe

RUN ln -s /generator/bin/index.js /generator/bin/readme-generator

RUN adduser --disabled-password \
  --home /generator \
  --gecos '' runner && chown -R runner /generator

COPY generate.sh /usr/bin/generate
RUN chmod +x /usr/bin/generate

USER runner

ENV PATH="/generator/bin:$PATH"

ENTRYPOINT ["generate"]
