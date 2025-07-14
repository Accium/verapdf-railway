FROM verapdf/rest:latest

# Copiamos la configuración de validación “verbose”
COPY verapdf-config/validator.xml   /opt/verapdf-rest/config/validator.xml

# Copiamos la configuración de extracción de features
COPY verapdf-config/features.xml    /opt/verapdf-rest/config/features.xml

EXPOSE 8080
