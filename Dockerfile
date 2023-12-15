#FROM maven:3.8.5-openjdk-8 AS build
#COPY . .
#
#RUN mvn clean package -DskipTests
#
#FROM openjdk:8-jdk-slim
#COPY --from=build /target/Ecommerce-0.0.1-SNAPSHOT.jar Ecommerce.jar
#
#EXPOSE 9090
#
#CMD ["java", "-jar", "Ecommerce.jar"]


#New docker file
# Stage 1: Build the application
FROM maven:3.8.5-openjdk-8 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
FROM openjdk:8-jre-slim

WORKDIR /app

COPY --from=build /app/target/Ecommerce-0.0.1-SNAPSHOT.jar /app/Ecommerce.jar

EXPOSE 9090

CMD ["java", "-Xmx512m", "-jar", "Ecommerce.jar"]

# Optional: Health check
HEALTHCHECK CMD curl --fail http://localhost:9090/actuator/health || exit 1
