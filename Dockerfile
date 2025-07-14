FROM verapdf/rest:latest

COPY verapdf-config/validator.xml /opt/verapdf-rest/config/validator.xml
COPY verapdf-config/features.xml  /opt/verapdf-rest/config/features.xml

# Crea la carpeta de logs con permisos
RUN mkdir -p /var/opt/verapdf-rest/logs \
  && chown verapdf-rest:verapdf-rest /var/opt/verapdf-rest/logs

EXPOSE 8080 8081

ENTRYPOINT [ "dumb-init", "--" ]
CMD ["java", "-jar", "/opt/verapdf-rest/verapdf-rest.jar", "server", "/var/opt/verapdf-rest/config/server.yml"]
