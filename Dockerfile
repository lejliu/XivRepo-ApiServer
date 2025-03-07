FROM rust:1.52.1 as build
ENV PKG_CONFIG_ALLOW_CROSS=1

WORKDIR /usr/src/apiserver
# Download and compile deps
COPY Cargo.toml .
COPY Cargo.lock .
COPY docker_utils/dummy.rs .
# Change temporarely the path of the code
RUN sed -i 's|src/main.rs|dummy.rs|' Cargo.toml
# Build only deps
RUN cargo build --release
# Now return the file back to normal
RUN sed -i 's|dummy.rs|src/main.rs|' Cargo.toml

# Copy everything
COPY . .
# Add the wait script
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait
# Build our code
ARG SQLX_OFFLINE=true
RUN cargo build --release


FROM bitnami/minideb:latest
RUN install_packages openssl ca-certificates
COPY --from=build /usr/src/apiserver/target/release/xivrepo /apiserver/xivrepo
COPY --from=build /usr/src/apiserver/migrations/* /apiserver/migrations/
COPY --from=build /wait /wait
WORKDIR /apiserver

EXPOSE 8000

CMD /wait && /apiserver/xivrepo
