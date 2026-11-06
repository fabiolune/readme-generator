FROM alpine/git:2.36.3 AS source

WORKDIR /generator
RUN git clone https://github.com/bitnami-labs/readme-generator-for-helm.git

FROM node:24-alpine

RUN apk update && apk upgrade --no-cache
RUN npm update -g npm
WORKDIR /app

COPY --from=source /generator/readme-generator-for-helm .

RUN npm install && \
    npm dedupe

RUN ln -s /app/bin/index.js /app/bin/readme-generator

RUN adduser --disabled-password \
  --home /app \
  --gecos '' runner && chown -R runner /app

COPY generate.sh /usr/bin/generate
RUN chmod +x /usr/bin/generate

USER runner

ENV PATH="/app/bin:$PATH"

ENTRYPOINT ["generate"]
