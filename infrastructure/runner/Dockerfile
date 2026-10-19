FROM ubuntu:24.04
ARG RUNNER_VERSION=2.328.0
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates git jq tar gzip openssh-client && rm -rf /var/lib/apt/lists/*
RUN useradd -m -u 10001 runner && mkdir -p /opt/actions-runner && chown runner:runner /opt/actions-runner
WORKDIR /opt/actions-runner
RUN curl -fsSL -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" && tar -xzf runner.tar.gz && rm runner.tar.gz && ./bin/installdependencies.sh
COPY --chown=runner:runner entrypoint.sh /opt/actions-runner/entrypoint.sh
RUN chmod +x /opt/actions-runner/entrypoint.sh
USER runner
ENTRYPOINT ["/opt/actions-runner/entrypoint.sh"]
