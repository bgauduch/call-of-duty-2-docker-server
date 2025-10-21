# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.1.0](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v5.0.3...v5.1.0) (2025-10-21)


### Features

* add automatic Docker Hub README sync ([#125](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/125)) ([7211989](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/7211989871119cf20e16700a0ad65eb15ffc6b13))

## [5.0.3](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v5.0.2...v5.0.3) (2025-10-21)


### Bug Fixes

* enable release-please to trigger build-test-push workflow ([#124](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/124)) ([28ffc84](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/28ffc84692a0c0a60f572d8b6fc1a88865556cfa))


### Miscellaneous

* **deps:** bump docker/build-push-action from 6.9.0 to 6.18.0 ([#119](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/119)) ([e287448](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/e28744837bf5ad2a7782578f73acaa574b2e8843))
* **deps:** bump googleapis/release-please-action from 4.1.3 to 4.3.0 ([#120](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/120)) ([d60f609](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/d60f609af42ff64410a4a5954952505ab94f9282))
* **deps:** update actions/checkout digest to 11bd719 ([#115](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/115)) ([2ab4f18](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/2ab4f188c0a3a48c7f8fcbd2e282a08731085646))
* **deps:** update actions/upload-artifact digest to 6f51ac0 ([#116](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/116)) ([3d818de](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/3d818de86c9ab9ab7b9100fc7581e2ac4e8282f6))
* **deps:** update github/codeql-action digest to 48ab28a ([#117](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/117)) ([b504f3a](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/b504f3a16c2294c385fb5134445f2716a0b629df))
* **deps:** update plexsystems/container-structure-test-action digest to c0a028a ([#118](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/118)) ([b9f8a77](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/b9f8a77acdb2f9a1069b79dad2ab9e1b7e8d3f3b))

## [5.0.2](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v5.0.1...v5.0.2) (2025-10-21)


### Code Refactoring

* Simplify workflows and minimize code duplication ([#121](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/121)) ([5a9ed90](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/5a9ed90a85f52a23e479db8f6524f9db95f707ba))

## [5.0.1](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v5.0.0...v5.0.1) (2025-10-19)


### Bug Fixes

* Add release trigger to build-test workflow ([#113](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/113)) ([dd5d814](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/dd5d814d6eb7eb7dc7e3b6bd02efcc203488a679))

## [5.0.0](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v4.3.0...v5.0.0) (2025-10-19)


### ⚠ BREAKING CHANGES

* The monolithic lint-build-push workflow has been replaced with modular workflows (lint.yml, build-test.yml, push-release.yml). Users relying on the old workflow file or specific job names in their automation must update to reference the new workflow structure.

### Features

* Refactor GitHub Actions into modular workflows with comprehensive testing ([#111](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/111)) ([2f0428c](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/2f0428c5ecc3462dcd99cde1178799736c84fc1a))

## [4.3.0](https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v4.2.0...v4.3.0) (2025-10-18)


### Features

* Add automated release management with Release Please ([#109](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/109)) ([6fd79ee](https://github.com/bgauduch/call-of-duty-2-docker-server/commit/6fd79ee72e9e14282d67076aaa9bef8130be88b6))

## [Unreleased]

## [4.2.0] - 2025-10-18

### Added
- CHANGELOG.md to track version history following Keep a Changelog format
- CODE_OF_CONDUCT.md based on Contributor Covenant v2.0
- CLAUDE.md configuration file for AI assistant guidance
- .gitattributes for consistent line endings across platforms
- Comprehensive versioning and tagging strategy documentation in CONTRIBUTING.md
- OCI standard image labels in Dockerfile
- Dependabot configuration for automated dependency updates
- ShellCheck linting for shell scripts in CI pipeline

### Changed
- Removed deprecated `version` field from docker-compose files (V2 specification)
- Updated LICENSE copyright year to 2015-2025 with full name
- Pinned all GitHub Actions to SHA commits with version comments for supply chain security
- Switched to official hadolint/hadolint-action for Dockerfile linting
- Replaced manual docker login with official docker/login-action in CI workflow
- Enhanced CONTRIBUTING.md with detailed versioning strategy and tag lifecycle documentation

### Fixed
- Replaced hardcoded container names with docker-compose commands in dev scripts
- Fixed .gitignore typo: .DS_store → .DS_Store (case-sensitive)
- Fixed .gitignore comment typo: exlude → exclude

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

[Unreleased]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v4.2.0...HEAD
[4.2.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v4.1...v4.2.0
[4.1.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/4.0...v4.1
[4.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/3.1...4.0
[3.1]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/3.0...3.1
[3.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/2.1...3.0
[2.1]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/2.0...2.1
[2.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/compare/v1.0...2.0
[1.0]: https://github.com/bgauduch/call-of-duty-2-docker-server/releases/tag/v1.0
