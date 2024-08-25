# Dockerfile in elysian_admin/sonarqube/docker
FROM sonarqube:10.6.0-community

# Switch to the root user temporarily to perform administrative tasks
USER root

# Set the working directory
WORKDIR /opt/sonarqube

# Copy the custom entrypoint.sh script
COPY scripts/entrypoint.sh /scripts/container-entrypoint.sh

# Copy the run_sonarqube_analysis.sh script
COPY scripts/run_sonarqube_analysis.sh /scripts/run_sonarqube_analysis.sh

# Ensure the custom entrypoint.sh is executable
RUN chmod +x /scripts/container-entrypoint.sh

# Ensure the run_sonarqube_analysis.sh is executable
RUN chmod +x /scripts/run_sonarqube_analysis.sh

# Symlink the run_sonarqube_analysis.sh script to /usr/local/bin/analyze
RUN ln -s /run_sonarqube_analysis.sh /usr/local/bin/analyze

# Expose the necessary port
EXPOSE 9000/tcp

# Switch back to the SonarQube user for security purposes
USER sonarqube

# Use the custom entrypoint script
ENTRYPOINT ["/scripts/container-entrypoint.sh"]
