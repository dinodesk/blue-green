# Blue-Green FastAPI CI/CD Demo

This repository demonstrates an enterprise-style immutable Blue/Green delivery lifecycle using FastAPI, Docker, GitHub Actions, Terraform, AWS ECS, and an AWS Application Load Balancer (ALB).

## Delivery lifecycle

1. Developer creates or updates a branch.
2. Local FastAPI, Docker, test, and debug workflows provide a repeatable development loop.
3. A branch push triggers CI.
4. CI builds a new container image from the exact Git commit and produces an immutable build artifact.
5. The branch image can be deployed to an isolated QA environment for validation.
6. Automated and manual validation gates determine whether the change is ready to merge.
7. Merge to `main` starts a **new Docker build**. The branch image is not reused.
8. The main build receives a four-part application version: `Major.Minor.Release.Revision`.
9. The new immutable main image is deployed to UAT Blue.
10. UAT validation and approval are completed.
11. The exact UAT-tested image is deployed to Green **without rebuilding**.
12. The ALB switches traffic between Blue and Green.
13. Production uses the same immutable-image promotion model.
14. Rollback switches traffic back to the previously known-good environment/image.
15. Terraform manages persistent infrastructure; runtime traffic switching is handled separately.

### Traceability

`Git commit → image digest/version → environment → validation/approval → promotion`

The goal is that every deployed image can be traced back to the source commit that produced it, while promotion between environments does not introduce a rebuild.

## Local development

### Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/)
- Docker Desktop
- VS Code
- VS Code Python and Debugpy extensions

### Install dependencies

From Git Bash or a terminal at the repository root:

```bash
uv sync
```

### Run unit tests locally

Unit tests run directly against the Python application:

```bash
uv run pytest tests/test_api.py
```

The helper script can also be used for the local test suite:

```bash
./scripts/test.sh
```

### Build the Docker image

The canonical local Docker build uses Docker Compose:

```bash
./scripts/build.sh
```

Equivalent command:

```bash
docker compose build api
```

### Run the application in Docker

Start the application container:

```bash
docker compose up
```

Or rebuild before starting:

```bash
docker compose up --build
```

The API is exposed at:

```text
http://localhost:8000
```

Check the containerized application:

```bash
curl http://127.0.0.1:8000/health
```

Expected response:

```json
{"status":"ok"}
```

Stop the application:

```bash
docker compose down
```

View container logs:

```bash
docker compose logs -f api
```

### Run integration tests against Docker

Integration tests are intentionally designed to test the application **running in Docker**. They do not start a separate local Uvicorn process.

First start the container:

```bash
docker compose up -d
```

Then run:

```bash
uv run pytest tests/test_integration.py
```

The default target is `http://127.0.0.1:8000`. A different container endpoint can be supplied with `BASE_URL`:

```bash
BASE_URL=http://127.0.0.1:8000 uv run pytest tests/test_integration.py
```

When finished:

```bash
docker compose down
```

### Run the Docker load test

The load generator runs on the host and sends HTTP requests to the application exposed by the Docker container. This keeps the test focused on the real containerized HTTP endpoint.

Start Docker first:

```bash
docker compose up -d
```

Run the default 50-request health check:

```bash
./scripts/load-test.sh
```

Run more requests:

```bash
REQUESTS=200 ./scripts/load-test.sh http://127.0.0.1:8000/health
```

The script reports request count, failures, average latency, and p95 latency.

### Debug locally with VS Code

For debugging FastAPI directly on Windows:

1. Open the repository in VS Code.
2. Open **Run and Debug**.
3. Select **FastAPI: Debug Local**.
4. Press **F5**.

This launches Uvicorn directly from the local Python environment.

### Debug the actual Docker container

For debugging the application process running inside Docker:

1. Start the container:

```bash
docker compose up
```

2. In VS Code, open **Run and Debug**.
3. Select **FastAPI: Attach Docker**.
4. Press **F5**.
5. Set breakpoints in `app/` and exercise the API through `http://localhost:8000`.

The container exposes Debugpy on port `5678`, and VS Code maps the local workspace to `/app` inside the container.

### Build from VS Code

The default VS Code build task invokes:

```bash
./scripts/build.sh
```

Use **Terminal → Run Build Task** or **Ctrl+Shift+B**.

## API

The example application exposes:

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/health` | Container/application health check |
| POST | `/orders` | Create an in-memory order |
| GET | `/orders/{order_id}` | Retrieve an order |

The order API is intentionally simple; the primary purpose of the application is to demonstrate the delivery and deployment lifecycle.

## CI image policy

Every branch commit produces a new container build associated with the exact Git commit SHA.

Branch builds:

- Do not use `latest`.
- Do not publish a mutable branch-name deployment tag.
- Produce an immutable CI artifact that can be associated with the exact source commit.
- Can be used as the input to QA validation.

A merge to `main` always performs a **new build** rather than promoting the branch build directly.

## Main release image policy

The main build receives a four-part application version:

```text
Major.Minor.Release.Revision
```

Example:

```text
1.2.5.18
```

The revision identifies the individual release build on `main`. The resulting image digest is recorded as the immutable artifact identity.

After UAT validation, the exact same image is promoted to Green and later production. No rebuild occurs between these promotion stages.

## Infrastructure and AWS direction

The target deployment architecture uses:

- AWS ECS for container workloads.
- Separate Blue and Green ECS services/target groups.
- AWS Application Load Balancer for runtime traffic switching.
- Terraform for persistent infrastructure.
- GitHub Actions for CI/CD orchestration.
- Immutable container images for promotion and rollback.
- Environment-specific configuration and secret-management mechanisms.

Terraform should manage infrastructure state and desired configuration. Runtime Blue/Green traffic changes should be performed as an explicit deployment operation rather than requiring a full infrastructure change.

## Configuration and secrets

Configuration should be supplied through environment-specific configuration mechanisms.

Sensitive values must never be committed to Git or written to CI logs.

As the AWS implementation evolves, environment configuration, secret-management, and IAM requirements will be documented alongside the infrastructure.

## Repository structure

```text
.
├── app/
│   ├── main.py
│   └── models/
├── tests/
│   ├── test_api.py
│   └── test_integration.py
├── scripts/
│   ├── build.sh
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── load-test.sh
│   └── test.sh
├── .github/
│   └── workflows/
├── .vscode/
├── Dockerfile
├── docker-compose.yml
└── pyproject.toml
```

## Design principles

- **Immutable builds:** build once for each promotion path and preserve the resulting artifact identity.
- **No `latest`:** deployment artifacts are explicitly versioned or tied to immutable commit/digest identities.
- **Build once per release stage:** merging to `main` creates the release image; later environment promotion does not rebuild it.
- **Infrastructure as code:** persistent AWS resources are managed declaratively.
- **Runtime deployment control:** traffic switching is separated from infrastructure provisioning.
- **Automated verification:** health checks and integration tests validate the running container.
- **Auditable promotion:** source, artifact, environment, validation, and promotion remain traceable.
