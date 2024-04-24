FROM rust:slim-bookworm
RUN export PATH=/root/.cargo/bin:$PATH
WORKDIR /rust
