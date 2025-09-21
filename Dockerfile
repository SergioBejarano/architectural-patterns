# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven files for dependency caching
COPY pom.xml .
COPY src ./src

# Install Maven
RUN apt-get update && apt-get install -y maven

# Build the application
RUN mvn clean package -DskipTests

# Create final stage
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy jar file from build stage (buscar el JAR específico de Spring Boot)
COPY --from=0 /app/target/PropertyManager-1.0-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 9000

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=docker

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]