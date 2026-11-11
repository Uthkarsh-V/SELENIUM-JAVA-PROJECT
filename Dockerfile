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
# Maven + JDK 17 + Google Chrome
# ==========================================
FROM maven:3.9.9-eclipse-temurin-17
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

# Install Google Chrome Stable (Ubuntu 24.04 Noble has no native chromium deb package)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y --no-install-recommends /tmp/google-chrome.deb \
    && rm -f /tmp/google-chrome.deb \
    && rm -rf /var/lib/apt/lists/*

# Copy cached Maven dependencies and built project files
COPY --from=build /root/.m2 /root/.m2
COPY --from=build /app /app

# Google Chrome binary path (Selenium Manager resolves matching ChromeDriver)
ENV CHROME_BIN=/usr/bin/google-chrome

# Execute Selenium TestNG tests
CMD ["mvn", "test"]
