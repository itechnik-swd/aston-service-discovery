# Стадия сборки
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Стадия выполнения
FROM eclipse-temurin:17-jre-alpine
# Установка curl для healthcheck
RUN apk update && apk add --no-cache curl && rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java", "-jar", "app.jar"]