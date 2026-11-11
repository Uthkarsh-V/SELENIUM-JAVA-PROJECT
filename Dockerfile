FROM maven:3.9.9-eclipse-temurin-17
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

# Install Google Chrome Stable for headless Selenium execution on Ubuntu 24.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && curl -fsSL -o /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/google-chrome.deb \
    && rm -f /tmp/google-chrome.deb \
    && rm -rf /var/lib/apt/lists/* \
    && google-chrome --version

# Copy Maven configuration, TestNG suite, test source, and local HTML login page
COPY pom.xml testng.xml ./
COPY src ./src
COPY webpage ./webpage

# Download dependencies and compile Selenium TestNG tests
RUN mvn test-compile -B

# Google Chrome binary path (Selenium Manager resolves matching ChromeDriver)
ENV CHROME_BIN=/usr/bin/google-chrome

# Execute Selenium TestNG tests
CMD ["mvn", "test"]
