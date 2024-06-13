FROM eclipse-temurin:17.0.10_7-jdk-alpine as builder
ARG JAR_FILE
ADD ${JAR_FILE} app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# Grant the group the same permissions as the owner user for consistency
# Note that we do this permission change in the builder image to avoid creating large intermediary
# layers in the final runner image.
#
# Note - for the most part, the COPY command below will honor the permissions set for these files in the builder
# image. However, for any leading directories Docker has to create itself, permissions will match
# the default umask for Docker, which is not configurable at the time of writing.
# This is technically not an issue in most cases, since read access is always available and write
# access to these directories is almost never necessary
RUN chmod -R g=u "dependencies/"
RUN chmod -R g=u "spring-boot-loader/"
RUN chmod -R g=u "snapshot-dependencies/"
RUN chmod -R g=u "application/"

FROM eclipse-temurin:17.0.10_7-jre-alpine

VOLUME /tmp

# Expect all application files to be copied to this directory
RUN mkdir "/blc-app" && chown -R 1000:0 "/blc-app" && chmod -R g=u "/blc-app"

ADD ./docker-exec.sh docker-exec.sh
RUN chown 1000:0 "docker-exec.sh" && chmod ug+x "docker-exec.sh"
USER root
ADD ./tools-exec.sh tools-exec.sh
RUN chmod ug+x "tools-exec.sh"
ENV ALPINE="-alpine"
ENV IMAGEMAGICK_ACTIVE=""
ENV UPGRADE=""
RUN ./tools-exec.sh && rm -rf tools-exec.sh

# NOTE - because we aim to be compatible with both OpenShift (runs as random UID) and standard
# Kubernetes, we cannot have any user-specific configuration in our Dockerfile.
# For compatibility with standard Kubernetes, we explicitly switch to a non-root UID. OpenShift
# will ignore these settings and run as an arbitrary UID in the root group.
USER 1000

# We assume 1000 UID for standard Kubernetes, and an arbitrary UID + root group (0)
# for OpenShift. Thus, grant both of those ownership here.
# Also, move the application files into the "/blc-app" directory (used by the entrypoint script).
COPY --chown=1000:0 --from=builder dependencies/ /blc-app
COPY --chown=1000:0 --from=builder spring-boot-loader/ /blc-app
COPY --chown=1000:0 --from=builder snapshot-dependencies/ /blc-app
COPY --chown=1000:0 --from=builder application/ /blc-app



# Use the 'exec form' of entrypoint to ensure signals like 'KILL' are forwarded to the running process.
# https://docs.docker.com/engine/reference/builder/#exec-form-entrypoint-example
ENTRYPOINT ["./docker-exec.sh"]
