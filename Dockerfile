FROM eclipse-temurin:17-jre

RUN apt-get update \
 && apt-get install -y wget unzip \
 && wget https://openpreservation.org/downloads/verapdf/1.28/veraPDF-1.28-webapp.zip \
 && unzip veraPDF-1.28-webapp.zip -d /app \
 && rm veraPDF-1.28-webapp.zip

WORKDIR /app/veraPDF-webapp

EXPOSE 8080

CMD ["java", "-jar", "veraPDF-webapp.jar"]
