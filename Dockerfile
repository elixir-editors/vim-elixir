FROM ubuntu:latest as base
RUN useradd -m user
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt install -y bash bundler ruby-rspec xvfb
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim-gtk3
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

FROM base as user
USER user
RUN bundle config path .bundler-path
