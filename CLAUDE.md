# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a containerized Call of Duty 2 multiplayer game server with libcod support. It uses a multi-stage Docker build to create minimal runtime images for various server binary versions.

## Architecture

### Multi-Stage Docker Build

The project uses a two-stage Dockerfile:

1. **Build stage** (Debian-based): Compiles libcod from source and prepares the CoD2 server binary
   - Adds i386 architecture support for 32-bit binaries
   - Clones and builds libcod (C++ library with MySQL/SQLite support)
   - Location: [Dockerfile](Dockerfile) lines 9-40

2. **Runtime stage** (Alpine-based): Minimal final image with only necessary runtime dependencies
   - Runs as non-root user (UID/GID 1000)
   - Copies compiled libraries and binaries from build stage
   - Location: [Dockerfile](Dockerfile) lines 42-96

### Server Binary Versioning

The project supports multiple server versions and binary types through build arguments:
- `COD2_VERSION`: Server version (`1_0`, `1_2`, `1_3`)
- `COD2_LNXDED_TYPE`: Binary variant (e.g., `_nodelay_va_loc`, `_cracked`, etc.)

All binaries are stored in [bin/](bin/) directory. Binary naming conventions:
- `nodelay`: Reduces master server offline time requirement (30min → 5sec)
- `cracked`: Disables master server + nodelay
- `loc`: Suppresses non-localized string spam
- `va`: Security patch for va() function string overrun (>1024 chars)

The CI/CD workflow builds all 12 binary combinations on master/release events.

### Configuration Files

- **Production**: [docker-compose.yaml](docker-compose.yaml) - Uses pre-built images from Docker Hub
- **Development**: [docker-compose.dev.yaml](docker-compose.dev.yaml) - Overrides with local build configuration
- Server settings: `cod2server/main/server_mp.cfg` (mounted as volume, not in repo)
- Game files: `cod2server/main/iw_*.iwd` files (mounted as volume, not in repo)

## Development Commands

### Local Development Workflow

All development scripts are in [scripts/](scripts/) directory:

```bash
# Start/restart server locally (builds image from source)
./scripts/dev-up.sh

# View server logs in real-time
./scripts/dev-logs.sh

# Attach to server console (run game commands like 'status', 'map_rotate')
# Detach with: CTRL+P, CTRL+Q
./scripts/dev-attach.sh

# Open interactive shell in container
./scripts/dev-exec.sh

# Stop and cleanup containers
./scripts/dev-down.sh
```

**Important**: Always use `./scripts/dev-up.sh` for local builds. This ensures:
- Proper image rebuild with latest code changes
- Correct docker-compose override file usage
- Consistent development environment

### Testing Changes

Before committing:

1. Build and test locally: `./scripts/dev-up.sh`
2. Verify server starts: `./scripts/dev-logs.sh`
3. Lint Dockerfile: `docker run --rm -i hadolint/hadolint < Dockerfile`
4. ShellCheck runs automatically in CI

### CI/CD Pipeline

The [.github/workflows/lint-build-push.yml](.github/workflows/lint-build-push.yml) workflow:

1. **Lint**: Runs hadolint (Dockerfile) and ShellCheck (bash scripts)
2. **Build**: Builds default image (`1_3_nodelay_va_loc`) and scans with Trivy
3. **Push**: Pushes to Docker Hub on master branch
4. **Build All**: On master/release, builds all 12 binary combinations in parallel
5. **Push All**: On release events, pushes all variants with version tags

All GitHub Actions are pinned to SHA commits with version comments for supply chain security.

## Conventions and Standards

### Semantic Versioning

- Repository follows [Semantic Versioning 2.0.0](https://semver.org/)
- Version format: `vMAJOR.MINOR.PATCH` (e.g., `v4.1.0`)
- Tags **must** include the `v` prefix
- MAJOR: Breaking changes or incompatible API changes
- MINOR: New features, backwards-compatible
- PATCH: Bug fixes, backwards-compatible

### Conventional Commits

All commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `chore`: Maintenance tasks (dependencies, etc.)
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `ci`: CI/CD pipeline changes
- `perf`: Performance improvements
- `style`: Code style changes (formatting)

**Examples**:
```
feat: Add support for CoD2 version 1.3 cracked binary
fix: Resolve undefined TMPDIR variable in Dockerfile
chore(deps): Update alpine base image to 3.20
docs: Update CONTRIBUTING.md with script documentation
ci: Pin GitHub Actions to SHA commits for security
```

### Pull Request Process

**Required before pushing PR**:

1. **Local testing with scripts** (fast feedback loop):
   ```bash
   # Build and start server
   ./scripts/dev-up.sh

   # Verify server starts without errors
   ./scripts/dev-logs.sh

   # Test server console access
   ./scripts/dev-attach.sh

   # Cleanup when done
   ./scripts/dev-down.sh
   ```

2. **Local linting**:
   ```bash
   # Lint Dockerfile
   docker run --rm -i hadolint/hadolint < Dockerfile
   ```

3. **Commit message validation**:
   - Ensure commit follows Conventional Commits format
   - Use imperative mood ("Add feature" not "Added feature")
   - Keep first line under 72 characters

4. **Branch naming**:
   - Use descriptive names: `feature/`, `fix/`, `chore/`, etc.
   - Example: `feature/script-improvements`, `fix/dockerfile-tmpdir`

**After local validation**, push and create PR with:
- Clear title following Conventional Commits
- Description of changes
- Link to related issues
- Test results from local validation

This process ensures fast feedback and reduces CI failures.

## Version Tagging

- **Repository tags**: Use `vMAJOR.MINOR.PATCH` format (e.g., `v4.1.0`)
- **Docker image tags**:
  - `latest`: Built from master branch
  - `vX.Y.Z`: Release version (e.g., `v4.1.0`)
  - `X_Y_variant`: Specific binary version (e.g., `1_3_nodelay_va_loc`)

## Security Considerations

- Server runs as non-root user (`cod2`, UID/GID 1000)
- RCON password **must** be set in `server_mp.cfg` before deployment
- All dependencies pinned in CI (GitHub Actions via SHA, Docker base images via digest)
- Trivy vulnerability scanning on all builds
- See [.github/SECURITY.md](.github/SECURITY.md) for full security policy

## Game Files Requirements

Users must provide their own game files (not included in repo):
- `iw_00.iwd` through `iw_15.iwd` from original game
- Localization files: `localized_english_iw*.iwd` (or other language)

These are mounted via volume in `docker-compose.yaml` from `./cod2server/main/`

## Container Naming

Docker Compose V2 uses project-based naming:
- Container name pattern: `{project}_{service}_{replica}`
- Default: `call-of-duty-2-docker-server_cod2_server_1`
- Scripts should use `docker-compose exec cod2_server` rather than hardcoded names
