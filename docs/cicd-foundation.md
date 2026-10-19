# Blue-Green CI/CD foundation

## Target
- Windows 10/11 Docker Desktop with Linux containers
- Ephemeral self-hosted GitHub Actions runner in `infrastructure/runner`
- HashiCorp Vault container (local development only) in `infrastructure/vault`
- Floci AWS emulator with UI (existing installation; exact image/ports must be verified)
- DEV/QA deployed to Raspberry Pi using Docker Compose
- UAT/PROD deployed to AWS after environment approval
- Build once, publish digest, promote the same artifact

## Runner bootstrap
1. Install Docker Desktop and enable Linux containers / WSL2.
2. From `infrastructure/runner`, run `docker compose build`.
3. Obtain a short-lived registration token from GitHub repository Settings > Actions > Runners > New self-hosted runner.
4. Set RUNNER_TOKEN in the launching shell, not a committed file.
5. Run `docker compose up`. The runner is ephemeral; generate a fresh registration token on restart.
6. This runner image has Git/SSH tools but **not Docker CLI or a Docker daemon**. Docker builds require a separate isolated builder or a later, security-reviewed runner design.
7. Runner image currently targets Linux x64. Check host architecture and runner version before building.

## Vault bootstrap
1. Run `docker compose -f infrastructure/vault/compose.yml up -d`.
2. Access local UI at http://127.0.0.1:8200.
3. Initialize and unseal Vault using its documented process; store recovery/unseal materials outside Git.
4. Set up a scoped authentication method and policies before allowing any runner to retrieve secrets.
5. This config is **local development only**: HTTP is loopback-bound and must not be exposed to LAN or internet.

## Floci integration
Floci is distinct from LocalStack. Reuse the existing Floci container and UI.
Before adding a Compose file, verify its actual image, exposed ports, API endpoint,
supported AWS services, and compatibility with the project's Terraform providers.
Do not assume ECS/ECR, IAM or ALB behavior is equivalent to AWS.

## Security / rollout dependencies
- Do not put real credentials, runner tokens, Vault tokens, SSH private keys or state files in Git.
- Configure GitHub environment gates for QA, UAT and PROD as appropriate.
- Use OIDC short-lived AWS credentials for real AWS actions.
- Keep Pi deployment private via LAN/Tailscale; pin SSH host keys.
- Never run untrusted PR code on a self-hosted runner with secret or deployment access.
- Keep the actual AWS deployment separate from emulator validation.
- Confirm existing `.github/workflows` and `tf/` contents before modifying them.

## First validation
- Confirm runner registers and accepts a harmless manually triggered job.
- Confirm Vault initializes, unseals and returns a test secret via a scoped identity.
- Confirm Floci's health endpoint and AWS API compatibility independently.
- Confirm private connectivity from Windows to Pi.
- Only then wire up CI, immutable artifact creation, DEV/QA promotion and AWS UAT/PROD.
