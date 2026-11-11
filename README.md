# SELENIUM-JAVA-PROJECT

Maven Java Selenium + TestNG project testing a local HTML login page (`webpage/login.html`), packaged with a multi-stage `Dockerfile` and GitHub Actions CI/CD pipeline for Docker Hub (`uthkarshgowda/selenium-testng-automation`).

## Project Structure

```text
.
├── .github/workflows/selenium-tests.yml
├── Dockerfile
├── .dockerignore
├── .gitignore
├── pom.xml
├── testng.xml
├── src/test/java/LocalLoginTest.java
└── webpage/login.html
```

## Demo Credentials

- **Username:** `student`
- **Password:** `12345`

## Open & Run in Eclipse

1. Open Eclipse and choose **File → Import → Maven → Existing Maven Projects** (or open the project folder directly).
2. Right-click `testng.xml` → **Run As → TestNG Suite** (or right-click `pom.xml` → **Run As → Maven test**).

## Run via Maven CLI

```bash
mvn clean test
```

## Docker & Docker Hub

Build and run the test container locally:

```bash
docker build -t uthkarshgowda/selenium-testng-automation:latest .
docker run --rm uthkarshgowda/selenium-testng-automation:latest
```

Push manually to Docker Hub:

```bash
docker login -u uthkarshgowda
docker push uthkarshgowda/selenium-testng-automation:latest
```

### GitHub Actions CI/CD

On every push to `main`, [selenium-tests.yml](.github/workflows/selenium-tests.yml):
1. Runs `mvn clean test` with JDK 17 and Chrome.
2. Builds and pushes the Docker image to `uthkarshgowda/selenium-testng-automation` on Docker Hub (requires `DOCKERHUB_TOKEN` in repository **Settings → Secrets and variables → Actions**; `DOCKERHUB_USERNAME` defaults to `uthkarshgowda` if not explicitly set as a secret).
