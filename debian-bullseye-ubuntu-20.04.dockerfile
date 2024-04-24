FROM rust:slim-bullseye
RUN export PATH=/root/.cargo/bin:$PATH
WORKDIR /rust
