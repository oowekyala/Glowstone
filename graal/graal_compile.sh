#!/bin/bash
# Must be run from glowstone root dir (above graal)
# You need an env variable GRAALVM_HOME, root of your graal distro (above bin)


SRC_D="$(pwd)"
SCRIPTD="$SRC_D/graal"
CONFD="$SCRIPTD/conf"
WD=$(mktemp -d --suffix='-glowstone-graal-compile')


# set -e

cp -r "$SRC_D/target/glowstone.jar" "$WD"

pushd "$WD" || exit

"$GRAALVM_HOME/bin/native-image" \
    -J-Xmx4g \
    -jar glowstone.jar \
    --verbose \
    --enable-http \
    --enable-https \
    --enable-all-security-services \
    --allow-incomplete-classpath \
    --report-unsupported-elements-at-runtime \
    "-H:JNIConfigurationFiles=$CONFD/jni-config.json" \
    "-H:ReflectionConfigurationFiles=$CONFD/reflect-config.json" \
    "-H:ResourceConfigurationFiles=$CONFD/resource-config.json" \
    "-H:DynamicProxyConfigurationFiles=$CONFD/proxy-config.json" \
    -H:+TraceClassInitialization \
    -H:IncludeResourceBundles=strings,org.bukkit.craftbukkit.libs.jline.console.completer.CandidateListCompletionHandler \
    --initialize-at-build-time=org.bukkit.Material,com.google.common.base,com.google.common.collect \
    '--initialize-at-run-time=net.glowstone.inventory.ToolType$ToolMaterial' \
    -H:+ReportExceptionStackTraces $@

# "$GRAALVM_HOME/bin/native-image"     -J-Xmx4g     -jar glowstone.jar     --verbose     --enable-http     --allow-incomplete-classpath      --report-unsupported-elements-at-runtime     -H:+ReportExceptionStackTraces -H:Optimize=0  -H:+TraceClassInitialization --initialize-at-build-time=org.bukkit.Material,com.google.common.base,com.google.common.collect --initialize-at-run-time=net.glowstone.inventory.ToolType$ToolMaterial

# popd "$WD"

