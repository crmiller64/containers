CLASSPATH=$CATALINA_BASE/log4j2/lib/*:$CATALINA_BASE/log4j2/conf
LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
# Set min and max heap size so JVM won't need to resize the heap at runtime and cause your program to crash
JAVA_OPTS="$JAVA_OPTS -Xms8192m -Xmx8192m"
