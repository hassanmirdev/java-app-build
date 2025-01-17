# Step 1: Use an official Maven image to build the WAR file
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code into the container
COPY pom.xml .
COPY src ./src

# Run Maven to build the application and create the WAR file
RUN mvn clean package -DskipTests

# Step 2: Use a smaller OpenJDK image for running the WAR file
FROM openjdk:11-jre-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the WAR file from the build stage into the final image
# The path '/app/target/vprofile-v2.war' is where Maven typically places the WAR file after the build
COPY --from=build /app/target/vprofile-v2.war /app/vprofile-v2.war

# Expose port 8080 (adjust if your app uses a different port)
EXPOSE 8080

# Command to run the WAR file with java -jar
CMD ["java", "-jar", "vprofile-v2.war"]
