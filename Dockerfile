# Use latest stable channel SDK.
FROM dart:3.6.0 AS build

# Create working directory
WORKDIR /tmp

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

# Resolve app dependencies.
RUN dart pub get

# Load env variables
ARG PATH_ETL
ARG DATABASE_URL
ARG DATABASE_KEY

# compile Cron Scheduler
RUN dart compile exe --define=PATH_ETL=${PATH_ETL} --define=DATABASE_URL=${DATABASE_URL} --define=DATABASE_KEY=${DATABASE_KEY} bin/cron_scheduler.dart -o bin/cron_scheduler

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /tmp/bin/cron_scheduler /tmp/bin/

# Start Cron Scheduler.
CMD ["/tmp/bin/cron_scheduler"]
