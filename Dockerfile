FROM --platform=linux/amd64 ubuntu:22.10
RUN apt-get update && apt-get install patch libssl-dev
WORKDIR /src
COPY . .
ENTRYPOINT ["/bin/sh"]