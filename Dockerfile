FROM verapdf/rest:latest

# Bump this number (o la fecha) cada vez que necesitemos forzar un nuevo COPY
ARG CACHEBUST=20250714-1600

COPY verapdf-config/validator.xml /opt/verapdf-rest/config/validator.xml
COPY verapdf-config/features.xml  /opt/verapdf-rest/config/features.xml

# Ahora los COPY ya no se cachearán mientras cambie CACHEBUST
COPY verapdf-config/validator.xml /var/opt/verapdf-rest/config/validator.xml
COPY verapdf-config/features.xml  /var/opt/verapdf-rest/config/features.xml

RUN mkdir -p /var/opt/verapdf-rest/logs \
  && chown verapdf-rest:verapdf-rest /var/opt/verapdf-rest/logs

EXPOSE 8080 8081
ENTRYPOINT [ "dumb-init", "--" ]
CMD ["java", "-jar", "/opt/verapdf-rest/verapdf-rest.jar", "server", "/var/opt/verapdf-rest/config/server.yml"]
