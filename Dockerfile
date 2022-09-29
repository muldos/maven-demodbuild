FROM amazoncorretto:11

RUN mkdir /opt/app
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/opt/app/petclinic.jar"]