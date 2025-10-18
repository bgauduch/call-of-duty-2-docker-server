# Contributing to Call of Duty 2 Docker Server

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Versioning and Tagging Strategy](#versioning-and-tagging-strategy)
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

This script opens an interactive shell (`sh`) inside the running server container. Useful for:
- Inspecting file structure
- Checking file permissions
- Debugging configuration issues
- Manually testing commands

Exit the shell with `exit` or `CTRL+D`.

#### Cleanup

```bash
./scripts/dev-down.sh
```

This script stops and removes all containers, networks, and resources created by docker-compose. Use this when:
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

## Versioning and Tagging Strategy

This project follows a dual-tagging strategy for Git repository tags and Docker image tags to support multiple server binary versions.

### Git Repository Tags

We use [Semantic Versioning](https://semver.org/) with a `v` prefix for repository releases:

**Format**: `vMAJOR.MINOR.PATCH`

- `vMAJOR`: Breaking changes or major feature releases
- `vMINOR`: New features, backward-compatible
- `vPATCH`: Bug fixes and patches

**Examples**:

- `v4.1` - Current release with security fixes
- `v5.0` - Future major release with breaking changes
- `v4.2` - Future minor release with new features

**Historical Note**: Versions prior to `v4.1` used inconsistent tagging (`2.0`, `3.0`, `v1.0`). Starting with `v4.1`, we consistently use the `v` prefix following industry best practices adopted by projects like Kubernetes, Docker, and Linux kernel.

### Docker Image Tags

Docker images are published to [Docker Hub](https://hub.docker.com/r/bgauduch/cod2server) with multiple tag formats to support various use cases:

#### Tag Format Convention

**1. Latest Tag** (recommended for most users)

```
bgauduch/cod2server:latest
```

- Always points to the newest stable release
- Uses the default server binary (1.3 with nodelay_va_loc)
- Built from `master` branch on each release

**2. Release Version Tags**

```
bgauduch/cod2server:v4.1
bgauduch/cod2server:v4.0
```

- Specific release versions for reproducibility
- Matches Git repository tags
- Immutable - never changes once published

**3. Server Binary Version Tags**

```
bgauduch/cod2server:X_Y_zzzzzz
```

Where:

- `X_Y` = CoD2 server binary version (`1_0`, `1_2`, or `1_3`)
- `zzzzzz` = Binary declination/variant (see [bin folder README](bin/readme.md))

**Examples**:

```
bgauduch/cod2server:1_3_nodelay_va_loc  # Version 1.3 with nodelay and VA location
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

### Tag Lifecycle and Maintenance

#### When Creating a New Release

1. **Test thoroughly** using development workflow
2. **Update version** if making breaking changes
3. **Tag the release** using semantic versioning:

   ```bash
   git tag -a v4.2 -m "Release v4.2: Description of changes"
   git push origin v4.2
   ```

4. **Create GitHub release** with detailed changelog
5. **CI/CD automatically builds** and publishes Docker images

#### Docker Image Build Strategy

The [GitHub Actions workflow](.github/workflows/lint-build-push.yml) automatically:

- **On Pull Request**: Builds and tests images (no push)
- **On Push to Master**: Builds and pushes `latest` tag
- **On Release**: Builds and pushes:
  - Version-specific tag (e.g., `v4.1`)
  - All server binary variant tags
  - Updates `latest` tag

#### Tag Immutability

- **Git tags**: Never delete or move published release tags
- **Docker release tags**: Immutable once published (e.g., `v4.1` never changes)
- **Docker `latest` tag**: Mutable, always points to newest release
- **Docker binary tags**: Rebuilt on releases to incorporate security updates

### Choosing the Right Tag

**For Production Users**:

- Use specific version tags for predictability: `bgauduch/cod2server:v4.1`
- Pin to exact versions in `docker-compose.yaml`

**For Development/Testing**:

- Use `latest` tag: `bgauduch/cod2server:latest`
- Always pulls newest features and fixes

**For Specific Server Binary Needs**:

- Use binary version tags: `bgauduch/cod2server:1_2_c_nodelay`
- Choose based on your server requirements

### Version Numbering Guidelines

**MAJOR version** (vX.0.0) - Increment when:

- Breaking changes to container interface
- Removal of deprecated features
- Major architectural changes
- Changes requiring user migration steps

**MINOR version** (v4.X.0) - Increment when:

- New features added (backward-compatible)
- New server binary versions supported
- Significant improvements
- Dependencies updated with new features

**PATCH version** (v4.1.X) - Increment when:

- Bug fixes
- Security patches
- Documentation updates
- Minor dependency updates

## Pull Request Process

1. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the development guidelines

3. **Commit your changes** with clear, descriptive commit messages:
   ```bash
   git commit -m "Add feature: brief description"
   ```

   Good commit messages:
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

7. **Wait for review**: A maintainer will review your PR. Be prepared to make changes based on feedback.

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
