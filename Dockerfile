# ==========================================
# STAGE 1: BUILD
# Maven + JDK 17
# ==========================================
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven configuration, TestNG suite, source code, and local HTML page
COPY pom.xml testng.xml ./
COPY src ./src
COPY webpage ./webpage

# Download dependencies and compile TestNG test classes
RUN mvn dependency:go-offline -B && mvn test-compile

# ==========================================
# STAGE 2: RUNTIME
# Maven + JDK 17 + Chromium
# ==========================================
FROM maven:3.9.9-eclipse-temurin-17
WORKDIR /app

# Install Chromium and matching ChromeDriver for headless Selenium execution
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Copy cached Maven dependencies and built project files
COPY --from=build /root/.m2 /root/.m2
COPY --from=build /app /app

# Chromium & ChromeDriver configuration
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# Execute Selenium TestNG tests
CMD ["mvn", "test"]
