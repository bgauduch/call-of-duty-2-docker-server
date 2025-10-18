# Release Process

This repository uses [Release Please](https://github.com/googleapis/release-please)
to automate the release process.

## How It Works

Release Please automates the following:

1. **Tracks changes** based on conventional commit messages
2. **Creates release PRs** with updated CHANGELOG and version bumps
3. **Publishes GitHub releases** when the release PR is merged
4. **Triggers Docker image builds** for all variants

## Conventional Commits

Use conventional commit messages to trigger automatic version bumps and
changelog updates:

### Commit Types

| Type | Description | Version Bump | Example |
|------|-------------|--------------|---------|
| `feat:` | New feature | Minor (x.Y.0) | `feat: Add support for custom maps` |
| `fix:` | Bug fix | Patch (x.x.Y) | `fix: Resolve server crash on startup` |
| `perf:` | Performance improvement | Patch | `perf: Optimize container startup time` |
| `docs:` | Documentation only | Patch | `docs: Update installation guide` |
| `refactor:` | Code refactoring | Patch | `refactor: Simplify Docker entrypoint` |
| `chore:` | Maintenance tasks | Patch | `chore: Update dependencies` |
| `BREAKING CHANGE:` | Breaking change | Major (X.0.0) | See below |

### Examples

**Feature (minor version bump):**

```bash
git commit -m "feat: Add LibCOD MySQL configuration options"
```

**Bug fix (patch version bump):**

```bash
git commit -m "fix: Correct file permissions in container"
```

**Breaking change (major version bump):**

```bash
git commit -m "feat!: Change environment variable naming convention

BREAKING CHANGE: Environment variables now use COD2_ prefix instead of GAME_ prefix"
```

**Documentation (appears in changelog):**

```bash
git commit -m "docs: Add troubleshooting section to README"
```

**Chore (appears in changelog under Miscellaneous):**

```bash
git commit -m "chore: Update Alpine base image to 3.20"
```

## Release Workflow

### Automated Process

1. **Developer workflow:**
   - Create feature branch
   - Make changes with conventional commits
   - Open PR to `master`
   - Merge PR after review

2. **Release Please automation:**
   - Analyzes commits since last release
   - Determines version bump (major/minor/patch)
   - Creates/updates a "release PR" with:
     - Updated `CHANGELOG.md`
     - Updated `.release-please-manifest.json`
     - Release notes

3. **Maintainer action:**
   - Review the release PR
   - Merge when ready to release

4. **Automatic release:**
   - Release Please creates GitHub release
   - Tags repository with new version (e.g., `v4.3.0`)
   - Triggers Docker image build workflow
   - Builds and pushes all Docker image variants

### Manual Intervention (if needed)

If you need to manually create a release:

1. Update version in `.release-please-manifest.json`
2. Update `CHANGELOG.md` following
   [Keep a Changelog](https://keepachangelog.com/) format
3. Create and push a tag:

   ```bash
   git tag -a v4.3.0 -m "Release v4.3.0"
   git push origin v4.3.0
   ```

4. Create GitHub release from the tag

## Docker Image Publishing

On release, the CI/CD workflow automatically:

1. **Builds all image variants** (12 different combinations):
   - Version 1.0: `1_0_a`, `1_0_a_va`, `1_0_a_va_loc`
   - Version 1.2: `1_2_c`, `1_2_c_nodelay`, `1_2_c_nodelay_va_loc`, `1_2_c_patch_va_loc`
   - Version 1.3: `1_3`, `1_3_cracked`, `1_3_nodelay`, `1_3_patch_va_loc`, `1_3_nodelay_va_loc`

2. **Pushes to Docker Hub** with tags:
   - `latest` (default: 1.3_nodelay_va_loc)
   - All variant tags (e.g., `1_3_nodelay_va_loc`)

3. **Runs security scans** (Trivy) on all images

## Best Practices

1. **Use conventional commits** for all changes to enable automatic versioning
2. **Review release PRs carefully** before merging
3. **Test changes locally** using development scripts before merging
4. **Document breaking changes** clearly in commit messages
5. **Keep CHANGELOG format consistent** (automated by Release Please)

## Versioning Strategy

Following [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes, major architectural updates
- **MINOR** (x.Y.0): New features, backward-compatible changes
- **PATCH** (x.x.Y): Bug fixes, security patches, documentation

## Troubleshooting

### Release Please PR not created

- Ensure commits use conventional commit format
- Check that commits are on `master` branch
- Verify `.release-please-manifest.json` exists and is valid

### Docker images not publishing

- Check GitHub Actions workflow status
- Verify Docker Hub credentials are configured in repository secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_PASSWORD`
- Ensure release was properly created (not just tagged)

### Version not incrementing correctly

- Review commit messages for proper conventional commit format
- Check for `BREAKING CHANGE:` in commit body for major bumps
- Verify `.release-please-manifest.json` has correct current version

## Resources

- [Release Please Documentation](https://github.com/googleapis/release-please)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
