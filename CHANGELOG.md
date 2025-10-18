# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CHANGELOG.md to track version history
- Comprehensive CLAUDE.md configuration file for AI assistant guidance

### Changed
- Updated LICENSE copyright year to 2015-2025

### Fixed
- Replaced hardcoded container names with docker-compose commands in dev scripts

## [4.1.0] - 2025-01-17

### Added
- SECURITY.md with comprehensive security policy and vulnerability reporting guidelines
- Non-root user execution in container (UID/GID 1000)
- Detailed development script documentation in CONTRIBUTING.md
- CI/CD security improvements with SHA-pinned GitHub Actions
- ShellCheck linting for shell scripts in CI pipeline
- Dependabot configuration for automated dependency updates
- OCI standard image labels in Dockerfile

### Changed
- Removed deprecated `version` field from docker-compose files (V2 specification)
- Enhanced README.md with links to SECURITY.md and CONTRIBUTING.md
- Switched to official hadolint/hadolint-action for Dockerfile linting
- Replaced manual docker login with official docker/login-action

### Fixed
- Undefined TMPDIR variable in Dockerfile build stage
- Security vulnerabilities related to root user execution

### Note
- Adopted `v` prefix for version tags (v4.1.0) as industry standard

## [4.0] - 2024-03-15

### Added
- Repository infrastructure improvements
- Enhanced security measures

## [3.1] - 2022-08-01

### Changed
- Updated Alpine base image to 3.16.0

## [3.0] - 2021-12-01

### Changed
- Major version update with infrastructure improvements

## [2.1] - 2021-08-01

### Changed
- Updated dependencies and base images

## [2.0] - 2021-06-01

### Changed
- Major version update with significant improvements

## [1.0] - 2015-01-01

### Added
- Initial release of Call of Duty 2 Docker Server
- Multi-stage Docker build with Debian and Alpine
- Support for multiple CoD2 server versions (1.0, 1.2, 1.3)
- Support for various server binary types (cracked, nodelay, va, loc)
- LibCOD integration with MySQL support
- Docker Compose configuration
- Development helper scripts
- Basic documentation

[Unreleased]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v4.1.0...HEAD
[4.1.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/4.0...v4.1.0
[4.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/3.1...4.0
[3.1]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/3.0...3.1
[3.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/2.1...3.0
[2.1]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/2.0...2.1
[2.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v1.0...2.0
[1.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/releases/tag/v1.0
