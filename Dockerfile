FROM dart:3.6.0 AS build

# Create working directory
WORKDIR /tmp

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

# Resolve app dependencies.
RUN dart pub get

# Load env variables
ARG pathEtl

# Compile server
RUN dart compile exe \
    --define=pathEtl=${pathEtl} \
    bin/server.dart \
    -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /tmp/bin/server /tmp/bin/

# Start server
CMD ["/tmp/bin/server"]
