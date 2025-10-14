# Contributing to Call of Duty 2 Docker Server

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

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

Follow the development guidelines in the [README.md](README.md#-development-guidelines) to set up your local environment:

```bash
./scripts/dev-up.sh      # Start the server
./scripts/dev-logs.sh    # View logs
./scripts/dev-attach.sh  # Attach to server console
./scripts/dev-exec.sh    # Execute commands in container
./scripts/dev-down.sh    # Stop and cleanup
```

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
