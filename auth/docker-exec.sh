#!/bin/sh

# Used as the 'entrypoint' script in base images to start a Spring Boot application.

if [ "$DEBUG_PORT" ]; then
  export JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:$DEBUG_PORT"
fi

export JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Dspring.cloud.bootstrap.enabled=true --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED"

# Expect the actual application files to be in this directory. Default is '/blc-app', which
# the base image Dockerfiles create. However, if the final image defines it in a separate location,
# they can override the default via this 'ENTRYPOINT_BLC_APP_DIRECTORY' environment variable.
if [ -z "$ENTRYPOINT_BLC_APP_DIRECTORY" ]; then
  echo "ENTRYPOINT_BLC_APP_DIRECTORY was not explicitly provided, using default as launch location: '/blc-app'"
  export ENTRYPOINT_BLC_APP_DIRECTORY="/blc-app"
else
  echo "ENTRYPOINT_BLC_APP_DIRECTORY was explicitly provided, using it as launch location: '$ENTRYPOINT_BLC_APP_DIRECTORY'"
fi
cd "$ENTRYPOINT_BLC_APP_DIRECTORY" || exit 1

# The container will be running either in standard Kubernetes as a consistent user
# (ex: UID 1000), or in OpenShift as a random UID under the root group.
#
# While volume mount configuration is responsible for basic ownership and permission settings, it
# does not guarantee equal file access by all containers, particularly for files _created_ by the
# containers. The default 'umask' setting on many distributions is '022', which grants the owner
# user 'read'/'write', but only grants the owner group 'read'. This would be problematic in OpenShift,
# where the UID is not consistent and only the GID is. We need to ensure that if a container with
# UID 1 creates a file, a container with UID 2 will be able to have the same access ('read'/'write')
# to that file.
#
# By overriding the umask of the entrypoint process to a sensible default of '002', the owner user
# and group will both be given equivalent 'read'/'write' access to the files (and
# 'read'/'write'/'search' on directories). This ensures all files created by the running application
# will be equally accessible by other instances of the application (when targeting a shared volume),
# even when their UIDs differ.
if [ "$DISABLE_ENTRYPOINT_UMASK_OVERRIDE" ]; then
  echo "DISABLE_ENTRYPOINT_UMASK_OVERRIDE was set, so not adjusting umask configuration"
else
  echo "DISABLE_ENTRYPOINT_UMASK_OVERRIDE was not set, so setting umask configuration to '0002'"
  umask 0002
  printf "umask is now '%s'\n" "$(umask)"
fi

# Moved into a shell script because the above 'export' statements cannot be retrieved
# between multiple statements in a Dockerfile
echo "Starting Java with the arguments '$JAVA_OPTS'"

# Use 'exec' to ensure the running process responds to signals like 'KILL'
#
# This command assumes the image will _not_ use a Spring Boot fat JAR and will instead
# run something like 'java -Djarmode=layertools -jar app.jar extract' to pre-explode the JAR
# contents and copy them directly.
exec java $JAVA_OPTS org.springframework.boot.loader.JarLauncher
