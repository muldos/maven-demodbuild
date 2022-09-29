ARG JAR_NAME=petclinic.jar
FROM amazoncorretto:11

RUN mkdir /opt/app
ADD $JAR_NAME /opt/app/petclinic.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/opt/app/petclinic.jar"]