#!/usr/bin/env bash
# ==============================================================================
# Plane LLM Hub - One-Click Launch Script for Linux / macOS
# ==============================================================================
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

echo "=================================================================="
echo " ✈️  Starting Plane LLM Hub (Vue2 + Spring Boot + MyBatis XML)"
echo "=================================================================="

# Check Java installation
if ! command -v java >/dev/null 2>&1; then
    echo "[ERROR] Java 17+ is required but 'java' command was not found in PATH."
    echo "Please install OpenJDK 17 or higher (e.g. Temurin 17) and try again."
    exit 1
fi

JAVA_VER=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
echo "[INFO] Detected Java version: $JAVA_VER"

# Make mvnw executable if needed
if [ -f "./mvnw" ]; then
    chmod +x ./mvnw
fi

echo "[INFO] Building and starting Spring Boot Application on port 8080..."
echo "[INFO] Once started, access: http://localhost:8080"
echo "------------------------------------------------------------------"

./mvnw spring-boot:run
