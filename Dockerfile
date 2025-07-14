FROM verapdf/rest:latest

COPY verapdf-config/validator.xml   /opt/verapdf-rest/config/validator.xml
COPY verapdf-config/features.xml    /opt/verapdf-rest/config/features.xml
ENV VERAPDF_LOG_LEVEL=DEBUG

EXPOSE 8080
