FROM almalinux:8.8

# https://almalinux.org/blog/2023-12-20-almalinux-8-key-update/
#
# On January 12, 2024 we will start signing RPM packages and repodata for AlmaLinux 8 with the updated GPG key.
# Taking the steps below will allow you to continue to recieve updates without problems when we make the switch.
# If you want to make sure your system already includes and trusts new AlmaLinux 8 GPG key you can just import it:
RUN rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux

# Install stuff for compiling stuff :)
RUN yum groupinstall -y 'Development Tools'

# cache buster
ARG BUILD_TIMESTAMP
LABEL buildTimestamp=$BUILD_TIMESTAMP

RUN curl -s https://sh.rustup.rs > rustup.rs && bash rustup.rs -y

RUN export PATH=/root/.cargo/bin:$PATH

WORKDIR /app
