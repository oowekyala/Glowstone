#!/bin/bash
# Must be run from glowstone root dir (above graal)
# You need an env variable GRAAL_HOME, root of your graal distro (above bin)


SRC_D="$(pwd)"
SCRIPTD="$SRC_D/graal"
WD=$(mktemp -d --suffix='-glowstone-graal-compile')


# set -e

cp -r "$SRC_D/target/glowstone.jar" "$WD"

pushd "$WD"

"$GRAAL_HOME/bin/native-image" \
    -J-Xmx4g \
    -jar glowstone.jar \
    --verbose \
    --enable-http \
    --allow-incomplete-classpath \
     --report-unsupported-elements-at-runtime \
    -H:+ReportExceptionStackTraces $@

# "$GRAAL_HOME/bin/native-image"     -J-Xmx4g     -jar glowstone.jar     --verbose     --enable-http     --allow-incomplete-classpath      --report-unsupported-elements-at-runtime     -H:+ReportExceptionStackTraces -H:Optimize=0  -H:+TraceClassInitialization --initialize-at-build-time=org.bukkit.Material,com.google.common.base,com.google.common.collect --initialize-at-run-time=net.glowstone.inventory.ToolType$ToolMaterial

# popd "$WD"

