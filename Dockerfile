FROM openjdk:8-jdk-alpine as builder

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootjar

FROM openjdk:8-jdk-alpine
COPY --from=builder build/libs/gs-spring-boot-docker-0.1.0.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]