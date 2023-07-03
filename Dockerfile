FROM adoptopenjdk/openjdk11:alpine-jre

ARG artifact=target/ResturantSite.war

WORKDIR /opt/app

COPY ${artifact} app.war

# This should not be changed
ENTRYPOINT ["java","-jar","app.war"]
