#FROM frolvlad/alpine-java:jdk8-slim
#VOLUME /tmp
#ADD ./build/libs/gs-spring-boot-docker-0.1.0.jar app.jar
#RUN sh -c 'touch /app.jar'
#ENV JAVA_OPTS=""
#EXPOSE 5432
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

#FROM gradle:4.6-jdk8-alpine as compile
#COPY . /home/source/java
#WORKDIR /home/source/java
#USER root
#RUN chown -R gradle /home/source/java
#USER gradle
#RUN gradle clean build
#
#FROM openjdk:8-jre-alpine
#WORKDIR /home/application/java
#COPY --from=compile "/home/source/java/build/libs/gs-spring-boot-docker-0.1.0.jar" .
#EXPOSE 5432
#ENTRYPOINT [ "java", "-jar", "/home/application/java/gs-spring-boot-docker-0.1.0.jar"]

#FROM frolvlad/alpine-java:jdk8-slim AS TEMP_BUILD_IMAGE
#ENV APP_HOME=/usr/app/
#WORKDIR $APP_HOME
#COPY build.gradle settings.gradle gradlew $APP_HOME
#COPY gradle $APP_HOME/gradle
#RUN ./gradlew build || return 0
#COPY . .
#RUN ./gradlew build
#
#FROM frolvlad/alpine-java:jdk8-slim
#ENV ARTIFACT_NAME=gs-spring-boot-docker-0.1.0.jar
#ENV APP_HOME=/usr/app/
#WORKDIR $APP_HOME
#COPY --from=TEMP_BUILD_IMAGE $APP_HOME/build/libs/$ARTIFACT_NAME .
#EXPOSE 5432
#CMD java -jar gs-spring-boot-docker-0.1.0.jar

FROM openjdk:8 AS BUILD_IMAGE
ENV APP_HOME=/root/dev/myapp/
RUN mkdir -p $APP_HOME/src/main/java
WORKDIR $APP_HOME
COPY build.gradle gradlew gradlew.bat $APP_HOME
COPY gradle $APP_HOME/gradle
# download dependencies
RUN ./gradlew build -x test --continue
COPY . .
RUN ./gradlew build
RUN pwd && find /

FROM openjdk:8-jre
WORKDIR /root/dev/myapp
RUN pwd && find .
COPY --from=BUILD_IMAGE /root/dev/myapp/build/libs/gs-spring-boot-docker-0.1.0.jar .
EXPOSE 5432
CMD ["java","-jar","gs-spring-boot-docker-0.1.0.jar"]