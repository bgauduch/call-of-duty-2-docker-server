# Contributing to Call of Duty 2 Docker Server

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Versioning and Release Strategy](#versioning-and-release-strategy)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/call-of-duty-2-docker-server.git
   cd call-of-duty-2-docker-server
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/bgauduch/call-of-duty-2-docker-server.git
   ```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes**: Help us squash bugs
- **Feature additions**: Propose and implement new features
- **Documentation**: Improve or add documentation
- **Testing**: Add or improve tests
- **Performance improvements**: Optimize existing code
- **Security improvements**: Help us keep the project secure

### Before You Start

1. Check the [issue tracker](https://github.com/bgauduch/call-of-duty-2-docker-server/issues) to see if your issue/feature has already been reported
2. For major changes, please open an issue first to discuss what you would like to change
3. Make sure you have the required game files as specified in the [README.md](README.md)

## Development Guidelines

### Local Development Setup

The project includes several helper scripts in the `scripts/` directory to streamline local development:

#### Start / Restart the Server Locally

```bash
./scripts/dev-up.sh
```

This script will:

- Build the Docker image locally using development configuration
- Start the CoD2 server container in detached mode
- Use the `docker-compose.yaml` and `docker-compose.dev.yaml` configuration files

> **Note:** You will need the game files in the `cod2server/main` folder, as specified in the [README.md](README.md#-requirements) Requirements section.

#### Show Server Logs

```bash
./scripts/dev-logs.sh
```

This script tails the server logs in real-time, showing:

- Server startup messages
- Connection logs
- Game events
- Error messages

Use `CTRL+C` to stop following logs.

#### Execute Server Commands

```bash
./scripts/dev-attach.sh
```

This script attaches to the running server process, allowing you to run server console commands directly. Available commands are documented in [/doc/readme.md](doc/readme.md).

Example commands:
```
status          # Show server status
map_rotate      # Rotate to next map
map_restart     # Restart current map
```

> **Important:** Use the escape sequence `CTRL+P`, `CTRL+Q` to detach from the container without stopping it.

#### Run a Shell in the Server Container

```bash
./scripts/dev-exec.sh
```

This script opens an interactive shell (`sh`) inside the running server
container. Useful for:

- Inspecting file structure
- Checking file permissions
- Debugging configuration issues
- Manually testing commands

Exit the shell with `exit` or `CTRL+D`.

#### Cleanup

```bash
./scripts/dev-down.sh
```

This script stops and removes all containers, networks, and resources created
by docker-compose. Use this when:

- You're done with development/testing
- You need to start fresh
- You want to free up system resources

### Code Style

- Follow the existing code style in the project
- Use meaningful variable and function names
- Comment complex logic
- Keep Dockerfile instructions organized and well-commented

### Dockerfile Best Practices

- Use multi-stage builds to minimize final image size
- Combine RUN commands where appropriate to reduce layers
- Pin versions for reproducibility
- Order commands from least to most frequently changed for better caching
- Clean up temporary files and caches in the same RUN command

### Testing Your Changes

Before submitting a pull request:

1. Build the Docker image locally:

   ```bash
   ./scripts/dev-up.sh
   ```

2. Test that the server starts correctly:

   ```bash
   ./scripts/dev-logs.sh
   ```

3. Verify you can connect to the server and it functions as expected

4. Run the linter:

   ```bash
   docker run --rm -i hadolint/hadolint < Dockerfile
   ```

## Versioning and Release Strategy

This project follows a dual-tagging approach:

1. **Git Repository Tags** - Version the codebase and infrastructure (e.g., `v4.2.0`)
2. **Docker Image Tags** - Identify specific server binary variants (e.g., `1_3_nodelay_va_loc`)

**For complete details on the automated release process, see [.github/RELEASE_PROCESS.md](.github/RELEASE_PROCESS.md).**

### Git Repository Versioning

We use [Semantic Versioning](https://semver.org/) with a `v` prefix for
repository releases:

- **Format**: `vMAJOR.MINOR.PATCH` (e.g., `v4.2.0`)
- **Purpose**: Track infrastructure, Docker setup, and project evolution
- **Examples**: `v4.1.0`, `v4.2.0`, `v5.0.0`

**Automated Release Process:**

Releases are fully automated via
[Release Please](https://github.com/googleapis/release-please):

1. Use [Conventional Commits](https://www.conventionalcommits.org/) in your
   PRs (`feat:`, `fix:`, etc.)
2. Release Please creates a release PR automatically with version bump and
   CHANGELOG
3. Merge the release PR when ready → Release is published automatically
4. Git tag is created (e.g., `v4.3.0`)
5. Docker images are built and published to Docker Hub

**Conventional Commit Examples:**

- `feat: Add new feature` → Minor version bump (v4.Y.0)
- `fix: Bug fix` → Patch version bump (v4.2.Y)
- `feat!: Breaking change` → Major version bump (vX.0.0)

**Historical Note**: Versions prior to `v4.1` used inconsistent tagging
(`2.0`, `3.0`, `v1.0`). Starting with `v4.1`, we consistently use the `v`
prefix.

### Docker Image Tags

Docker images are published to
[Docker Hub](https://hub.docker.com/r/bgauduch/cod2server) with multiple tag
formats to support various use cases:

#### Tag Format Convention

**1. Latest Tag** (recommended for most users)

```text
bgauduch/cod2server:latest
```

- Always points to the newest stable release
- Uses the default server binary (1.3 with nodelay_va_loc)
- Built from `master` branch on each release

**2. Release Version Tags**

```text
bgauduch/cod2server:v4.1
bgauduch/cod2server:v4.0
```

- Specific release versions for reproducibility
- Matches Git repository tags
- Immutable - never changes once published

**3. Server Binary Version Tags**

```text
bgauduch/cod2server:X_Y_zzzzzz
```

Where:

- `X_Y` = CoD2 server binary version (`1_0`, `1_2`, or `1_3`)
- `zzzzzz` = Binary declination/variant
  (see [bin folder README](bin/readme.md))

**Examples**:

```text
bgauduch/cod2server:1_3_nodelay_va_loc  # Version 1.3 with nodelay and VA
bgauduch/cod2server:1_2_c_nodelay       # Version 1.2 cracked with nodelay
bgauduch/cod2server:1_0_a_va            # Version 1.0 with VA
```

#### Available Server Binary Versions

| Version | Description | Tags |
|---------|-------------|------|
| 1.0 | Original release | `1_0_a`, `1_0_a_va`, `1_0_a_va_loc` |
| 1.2 | Cracked version | `1_2_c`, `1_2_c_nodelay`, `1_2_c_nodelay_va_loc`, `1_2_c_patch_va_loc` |
| 1.3 | Latest stable | `1_3`, `1_3_cracked`, `1_3_nodelay`, `1_3_patch_va_loc`, `1_3_nodelay_va_loc` |

For detailed explanations of binary variants, see the [bin folder README](https://github.com/bgauduch/call-of-duty-2-docker-server/tree/master/bin).

#### Choosing the Right Docker Image Tag

**For Production Users**:

- Use specific version tags for predictability: `bgauduch/cod2server:v4.1`
- Pin to exact versions in `docker-compose.yaml`

**For Development/Testing**:

- Use `latest` tag: `bgauduch/cod2server:latest`
- Always pulls newest features and fixes

**For Specific Server Binary Needs**:

- Use binary version tags: `bgauduch/cod2server:1_2_c_nodelay`
- Choose based on your server requirements

## Pull Request Process

1. **Create a branch** for your changes:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the development guidelines

3. **Commit your changes** using
   [Conventional Commits](https://www.conventionalcommits.org/) format:

   ```bash
   git commit -m "feat: Add feature description"
   git commit -m "fix: Fix bug description"
   ```

   **Important**: Use conventional commit format to enable automatic
   versioning:

   - `feat:` - New feature (minor version bump)
   - `fix:` - Bug fix (patch version bump)
   - `docs:` - Documentation changes
   - `refactor:` - Code refactoring
   - `chore:` - Maintenance tasks
   - `feat!:` or `BREAKING CHANGE:` - Breaking changes (major version bump)

   See [.github/RELEASE_PROCESS.md](.github/RELEASE_PROCESS.md) for more
   details.

   Good commit message practices:

   - Use the present tense ("Add feature" not "Added feature")
   - Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
   - Limit the first line to 72 characters or less
   - Reference issues and pull requests when relevant

4. **Keep your branch up to date** with upstream:

   ```bash
   git fetch upstream
   git rebase upstream/master
   ```

5. **Push to your fork**:

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request** on GitHub with:

   - A clear title and description
   - Reference to any related issues
   - Screenshots or logs if applicable
   - List of changes made
   - Any breaking changes or migration notes

7. **Wait for review**: A maintainer will review your PR. Be prepared to
   make changes based on feedback.

### PR Checklist

- [ ] My code follows the project's code style
- [ ] I have tested my changes locally
- [ ] I have added/updated documentation as needed
- [ ] I have added tests if applicable
- [ ] My changes generate no new warnings or errors
- [ ] I have checked my code with hadolint
- [ ] All existing tests pass
- [ ] My commit messages are clear and descriptive

## Reporting Issues

### Bug Reports

When reporting a bug, please include:

- **Clear title and description** of the issue
- **Steps to reproduce** the bug
- **Expected behavior** vs actual behavior
- **Environment details**:
  - Docker version
  - Docker Compose version
  - Operating system
  - Image tag being used
- **Logs** from the server (use `./scripts/dev-logs.sh`)
- **Screenshots** if applicable

### Feature Requests

When requesting a feature:

- **Describe the feature** and its use case
- **Explain why** this feature would be useful
- **Provide examples** of how it would work
- **Note any alternatives** you've considered

## Questions?

If you have questions, feel free to:

- Open an issue with the `question` label
- Check existing issues and pull requests
- Review the [documentation](README.md)

## License

By contributing, you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers this project.

Thank you for contributing!
