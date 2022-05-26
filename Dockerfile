#Dockerfile
FROM openjdk:11 as base
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build

FROM tomcat:9
WORKDIR java_app
COPY --from=base /app/build/libs/java_app.war .
RUN rm -rf ROOT && mv java_app.war ROOT.war