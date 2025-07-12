FROM eclipse-temurin:17-jre

RUN apt-get update && apt-get install -y wget unzip \
 && wget https://github.com/veraPDF/veraPDF-library/releases/download/v1.25.652/veraPDF-1.25.652-webapp.zip \
 && unzip veraPDF-1.25.652-webapp.zip -d /app \
 && rm veraPDF-1.25.652-webapp.zip

WORKDIR /app/veraPDF-webapp

EXPOSE 8080

CMD ["java", "-jar", "veraPDF-webapp.jar"]
