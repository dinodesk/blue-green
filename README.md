# Blue-Green FastAPI CI/CD Demo

This repository demonstrates an enterprise-style immutable Blue/Green delivery lifecycle using FastAPI, Docker, GitHub Actions, Terraform, AWS ECS, and an AWS Application Load Balancer (ALB).

## Portfolio lifecycle

1. Developer creates or updates a branch.
2. Local FastAPI/Docker/test/debug workflow runs.
3. A branch push triggers the reusable GitHub Actions CI workflow.
4. The branch build creates a new image artifact identified by the exact Git commit and immutable artifact digest. No persistent mutable branch tag is used.
5. The exact branch image artifact is used for PR/QA deployment.
6. Automated QA validation runs against the deployed branch environment.
7. Manual QA approval permits promotion and merge.
8. Merge to `main` starts a **new** build. The branch image is not reused. Only this main build receives the four-part application version tag.
9. The new immutable main image is deployed to UAT Blue.
10. UAT automated/manual validation and approval are completed.
11. The exact UAT-tested image is deployed to Green without rebuilding.
12. ALB traffic is switched between Blue and Green.
13. Production follows the same immutable-image promotion model.
14. Rollback switches ALB traffic back to the previously known-good environment/image.
15. Terraform owns persistent infrastructure; the reusable traffic-switch script owns runtime ALB traffic changes.

### Traceability

`Git commit → image digest/version → environment → validation/approval → promotion`

## Jira story ownership

| Stage | Jira |
|---|---|
| Local FastAPI, Docker, tests, debug, initial CI foundation | BG-3 |
| PR immutable image publication | BG-6 |
| Branch/PR ECS environment and ALB infrastructure | BG-4 |
| Deploy PR image to QA Blue | BG-7 |
| Automated QA validation | BG-5 |
| Manual QA approval | BG-8 |
| Promote Blue to Green and merge | BG-9 |
| Main merge, new four-part release image, UAT Blue/Green | BG-10 |
| UAT validation | BG-11 |
| UAT approval / release readiness | BG-12 |
| Rollback and cleanup | BG-13 |
| Terraform modules, ALB, ECS, configuration, secrets, traffic switch | BG-14 |
| Four-part versioning and /version endpoint | BG-15 |
| Portfolio documentation | BG-2 |

## Local development

Prerequisites:

- Python 3.12+
- [uv](https://docs.astral.sh/uv/)
- Docker
- VS Code with Python/Debugpy support

Install and test:

```bash
uv sync
uv run pytest
```

Build and run:

```bash
./scripts/docker-build.sh
./scripts/docker-run.sh
```

Then check:

```text
GET http://localhost:8000/health
```

The example business API is:

- `POST /orders`
- `GET /orders/{order_id}`

The load test defaults to 50 health requests:

```bash
./scripts/load-test.sh
```

VS Code provides a Docker Build task and a FastAPI debug launch configuration.

## Branch CI image policy

Every branch commit produces a new build. The branch artifact is associated with the exact commit SHA and an immutable digest. There is no mutable `feature-x`, branch-name, or `latest` deployment tag.

The branch artifact is an intermediate CI artifact. BG-6 owns the formal PR/registry publication contract used by the later ECS QA deployment.

## Main release image policy

A merge to `main` triggers a **new Docker build**. The main build receives the four-part version from BG-15:

`Major.Minor.Release.Revision`

Example:

`1.2.5.18`

The version tag is created only for the main release image. The immutable digest is recorded and is the artifact identity used for UAT and later promotion.

The same image is promoted from UAT Blue to Green and onward without rebuilding.

## Configuration and secrets

Configuration should be supplied through environment/configuration mechanisms appropriate to each environment. Defaults and supply mechanisms should be documented as implementation evolves.

Sensitive values must never be committed to Git or written to CI logs.

## Scope of BG-3

BG-3 establishes the local FastAPI application, repeatable Docker/test/debug workflow, and reusable CI foundation.

AWS ECS, Terraform infrastructure, ALB traffic switching, QA approval, UAT, production deployment, release-version assignment implementation, and rollback are implemented by later Jira stories.
