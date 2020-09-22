#!/bin/bash
# Must be run from glowstone root dir (above graal)
# You need an env variable GRAALVM_HOME, root of your graal distro (above bin)


SRC_D="$(pwd)"
SCRIPTD="$SRC_D/graal"
CONFD="$SCRIPTD/conf"
WD="$SRC_D/target/graal-wd"


# set -e

mkdir -p "$WD"

pushd "$WD" || exit

# From netty conf files:
# --initialize-at-run-time=io.netty.buffer.PooledByteBufAllocator,io.netty.buffer.ByteBufAllocator,io.netty.buffer.ByteBufUtil,io.netty.buffer.AbstractReferenceCountedByteBuf

"$GRAALVM_HOME/bin/native-image" \
    --no-server \
    -J-Xmx8g \
    -jar "$SRC_D/target/glowstone.jar" glowstone-native \
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
    -H:IncludeResourceBundles=strings,commands,org.bukkit.craftbukkit.libs.jline.console.completer.CandidateListCompletionHandler \
    --initialize-at-build-time=org.bukkit.Material,com.google.common.base,com.google.common.collect,org.slf4j,org.slf4j.impl,io.netty.util.internal,io.netty.util.concurrent,io.netty.util.CharsetUtil,io.netty.util.Recycler \
    '--initialize-at-run-time=net.glowstone.inventory.ToolType$ToolMaterial' \
    -H:+ReportExceptionStackTraces $@

if [ $? -eq 0 ]; then
    mv -f glowstone-native ..
fi

popd

