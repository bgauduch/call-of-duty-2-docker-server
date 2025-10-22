# CLAUDE.md

Instructions for Claude Code when working with this Call of Duty 2 dedicated server repository.

## Project Overview

Containerized COD2 multiplayer dedicated server with libcod support using Docker multi-stage builds (Debian build → Alpine runtime).

**Architecture:**

- **12 server variants**: versions 1.0/1.2/1.3 with various patches (binaries in [bin/](bin/))
- **Multi-variant build**: All variants built via matrix strategy from [.github/config/variants.json](.github/config/variants.json)
- **Default variant**: `1_3_nodelay_va_loc` (v1.3 + nodelay + VA security + no localization spam)
- **Build args control variant**: `COD2_VERSION` (e.g., `1_3`), `COD2_LNXDED_TYPE` (e.g., `_nodelay_va_loc`)

**Key Binaries & Suffixes:**

- `_nodelay`: Reduces master server reconnect (30min → 5sec)
- `_va`: VA security patch for buffer overflow (recommended)
- `_loc`: Suppresses non-localized string spam
- `_cracked`: Disables master server + nodelay
- See [bin/readme.md](bin/readme.md) for details

## Quick Reference

### Development Scripts

| Command | Purpose |
|---------|---------|
| `./scripts/dev-build.sh` | Build local image |
| `./scripts/dev-up.sh` | Build and start server (detached) |
| `./scripts/dev-logs.sh` | View real-time logs |
| `./scripts/dev-attach.sh` | Attach to console (detach: CTRL+P, CTRL+Q) |
| `./scripts/dev-exec.sh` | Open shell in container |
| `./scripts/dev-down.sh` | Stop and cleanup |

### Testing & Linting

**Important:** Always run tests and linting locally before committing.

```bash
# Lint
docker run --rm -i hadolint/hadolint < Dockerfile
docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable scripts/*.sh

# Test
./container-structure-test-linux-amd64 test --image bgauduch/cod2server:dev --config tests/container-structure-test.yaml
./tests/test-container-health.sh bgauduch/cod2server:dev
```

## Build & Release System

### Binary Naming Convention

Format: `cod2_lnxded_X_Y[suffix]` (located in [bin/](bin/))

- `X_Y`: Version (`1_0`, `1_2`, `1_3`)
- `[suffix]`: Optional modifiers (`_nodelay`, `_va`, `_loc`, `_cracked`, `a`, `c`)

### Docker Image Tags

**Immutable:** `bgauduch/cod2server:4.2.0-1_3_nodelay_va_loc` (semver + variant)
**Mutable:** `latest`, `4`, `4.2`, `1_3_nodelay_va_loc`

### CI/CD Pipeline

[.github/workflows/build-test-push.yml](.github/workflows/build-test-push.yml):

1. Load config from [.github/config/variants.json](.github/config/variants.json)
1. Build all 12 variants (matrix strategy)
1. Run container structure tests + Trivy security scan
1. Save artifacts (zstd compression)
1. Push on release with semantic version tags

**Critical:** All variants built on every PR to ensure universal compatibility.

### Workflows

| Workflow | Trigger | Actions |
|----------|---------|---------|
| [Lint](.github/workflows/lint.yml) | PR/push | Hadolint (Dockerfile) + ShellCheck (scripts) |
| [Build/Test/Push](.github/workflows/build-test-push.yml) | PR/push/release | Build all 12 variants, test, scan, push |
| [Release Please](.github/workflows/release-please.yml) | Push to main | Create release PR, update CHANGELOG, trigger builds |

### Conventional Commits

| Type | Version Bump | Example |
|------|--------------|---------|
| `feat:` | Minor (x.Y.0) | `feat: add new map rotation` |
| `fix:` | Patch (x.x.Y) | `fix: resolve connection timeout` |
| `feat!:` or `BREAKING CHANGE:` | Major (X.0.0) | `feat!: change config format` |
| `docs:`, `refactor:`, `perf:`, `chore:` | Patch | Categorized in changelog |

See [.github/RELEASE_PROCESS.md](.github/RELEASE_PROCESS.md) for details.

## Project Structure

```text
bin/                      # COD2 server binaries (12 variants)
lib/pb/                   # PunkBuster files (v1.760)
cod2server/main/          # Volume mount for game files (.iwd)
Dockerfile                # Multi-stage build
docker-compose.yaml       # Production config
docker-compose.dev.yaml   # Development override
scripts/                  # Dev helper scripts
tests/                    # Container validation
.github/
  ├── workflows/          # CI/CD pipelines
  ├── config/variants.json    # Variant definitions
  └── actions/setup-config/   # Reusable config loader
```

## Configuration Reference

### Dockerfile Build Arguments

- `COD2_VERSION` - Server version (`1_0`, `1_2`, `1_3`)
- `COD2_LNXDED_TYPE` - Binary variant suffix (`_nodelay_va_loc`, `a`, `c`, etc.)
- `LIBCOD_GIT_URL` - libcod repository (default: voron00/libcod)
- `LIBCOD_MYSQL_TYPE` - MySQL support [0=disabled, 1=default, 2=experimental]

### Runtime Details

Server runs as non-root user `cod2` (UID 1000):

- Working directory: `/home/cod2`
- Game files volume: `/home/cod2/main` (contains .iwd files)
- Logs redirected: `/home/cod2/.callofduty2/main/games_mp.log` → stdout
- LibCOD preloaded via `LD_PRELOAD`

Customize server command in `docker-compose.yaml`:

```yaml
command: ["+set", "net_port", "28960", "+set", "sv_punkbuster", "0", "+exec", "server_mp.cfg"]
```

## Common Tasks

### Add New Server Variant

1. Add binary to [bin/](bin/): `cod2_lnxded_X_Y[suffix]`
1. Update [.github/config/variants.json](.github/config/variants.json):

   ```json
   {
     "cod2_version": "X_Y",
     "cod2_lnxded_type": "[suffix]"
   }
   ```

1. CI automatically builds and tests on next PR

### Test Dockerfile Changes

```bash
docker build \
  --build-arg COD2_VERSION=1_3 \
  --build-arg COD2_LNXDED_TYPE=_nodelay_va_loc \
  -t bgauduch/cod2server:test .

docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up
```

### Troubleshoot Build Failures

- Verify build args match existing binary in [bin/](bin/)
- Check i386 architecture support in build stage
- Ensure libcod compilation succeeds for target COD2_VERSION
- See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed troubleshooting

## Security & Requirements

### Security Best Practices

- **Use `_va` variants** (VA security patch for buffer overflow)
- **Change RCON password** in `cod2server/main/server_mp.cfg`
- Container runs as non-root with resource limits
- Trivy security scanning on all images
- See [.github/SECURITY.md](.github/SECURITY.md)

### Required Game Files

Server requires original game files in `cod2server/main/`:

- `iw_00.iwd` through `iw_15.iwd` (from retail game)
- `localized_english_iwXX.iwd` files (or other language)

**Note:** Without game files, container starts but health checks fail (expected in CI/CD).
