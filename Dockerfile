# 1) Builder: Clona el repo y compila veraPDF-rest con Maven
FROM maven:3-eclipse-temurin-11-alpine AS app-builder
RUN apk add --no-cache git
WORKDIR /build
ARG GH_CHECKOUT
ENV GH_CHECKOUT=${GH_CHECKOUT:-integration}
RUN git clone https://github.com/veraPDF/veraPDF-rest.git .
RUN git checkout ${GH_CHECKOUT}

# Copiamos tu configuración ANTES de compilar
COPY verapdf-config/validator.xml  config/validator.xml
COPY verapdf-config/features.xml   config/features.xml

# Empaquetamos el JAR
RUN mvn clean package -DskipTests

# 2) JRE minimal con jlink
FROM eclipse-temurin:11-jdk-alpine AS jre-builder
RUN "$JAVA_HOME/bin/jlink" \
    --add-modules java.base,java.logging,java.xml,java.management,java.sql,java.desktop,jdk.crypto.ec \
    --strip-debug --no-man-pages --no-header-files --compress=2 \
    --output /javaruntime

# 3) Imagen final de producción
FROM alpine:3
ARG VERAPDF_REST_VERSION
ENV VERAPDF_REST_VERSION=${VERAPDF_REST_VERSION:-1.29.1}

# dumb-init para manejo de PID 1
ADD --link https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Copiamos el JRE
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-builder /javaruntime $JAVA_HOME

# Usuario sin privilegios
RUN addgroup -S verapdf-rest && adduser --system -D --home /opt/verapdf-rest -G verapdf-rest verapdf-rest
RUN mkdir -p /var/opt/verapdf-rest/logs && chown -R verapdf-rest:verapdf-rest /var/opt/verapdf-rest
USER verapdf-rest
WORKDIR /opt/verapdf-rest

# Copiamos el JAR compilado
COPY --from=app-builder /build/target/verapdf-rest-${VERAPDF_REST_VERSION}.jar /opt/verapdf-rest/verapdf-rest.jar

# Copiamos server.yml al directorio que lee Dropwizard
COPY --from=app-builder /build/server.yml /var/opt/verapdf-rest/config/

# Copiamos la carpeta config (incluye validator.xml y features.xml)
COPY --from=app-builder /build/config /opt/verapdf-rest/config/

EXPOSE 8080 8081

ENTRYPOINT [ "dumb-init", "--" ]
CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/verapdf-rest/verapdf-rest.jar", "server", "/var/opt/verapdf-rest/config/server.yml"]
