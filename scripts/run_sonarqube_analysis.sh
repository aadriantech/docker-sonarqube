#!/bin/bash

# Ensure that the SONARQUBE_TOKEN environment variable is set
if [ -z "$SONARQUBE_TOKEN" ]; then
    echo "[ERROR] SONARQUBE_TOKEN is not set. Please ensure it is set in your environment before running the analysis."
    exit 1
fi

# Function to run SonarQube analysis
run_analysis() {
    PROJECT_PATH="/projects/$1"
    PROJECT_NAME=$(basename "$PROJECT_PATH")

    # SonarScanner command with necessary parameters
    sonar-scanner \
      -Dsonar.projectKey="$PROJECT_NAME" \
      -Dsonar.sources="$PROJECT_PATH" \
      -Dsonar.host.url=http://localhost:9000 \
      -Dsonar.login="$SONARQUBE_TOKEN"

    if [ $? -eq 0 ]; then
        echo "[SONARQUBE_ANALYSIS] SonarQube analysis completed for $PROJECT_NAME"
    else
        echo "[SONARQUBE_ANALYSIS] SonarQube analysis failed for $PROJECT_NAME"
    fi
}

# Function to run analysis for all projects
run_all_analyses() {
    IFS=',' read -r -a PROJECT_ARRAY <<< "$PROJECTS"
    for PROJECT in "${PROJECT_ARRAY[@]}"; do
        run_analysis "$PROJECT"
    done
}

# Main logic
if [ "$#" -eq 0 ]; then
    echo "[INFO] No project specified. Running analysis for all projects."
    run_all_analyses
elif [ "$#" -eq 1 ]; then
    PROJECT="$1"
    if [[ ",$PROJECTS," == *",$PROJECT,"* ]]; then
        run_analysis "$PROJECT"
    else
        echo "[ERROR] Project $1 is not listed in the PROJECTS environment variable."
        exit 1
    fi
else
    echo "[ERROR] Invalid number of arguments. Usage:"
    echo "  $0                # To scan all projects"
    echo "  $0 PROJECT_NAME   # To scan a specific project"
    exit 1
fi
