FROM maven:3.8.5-openjdk-8 AS build
COPY . .

RUN mvn clean package -DskipTests

FROM openjdk:8-jdk-slim

COPY --from=build target/major.jar .

EXPOSE 9090

CMD ["java", "-jar", "major.jar"]