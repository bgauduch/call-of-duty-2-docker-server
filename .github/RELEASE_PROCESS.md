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
   - Open PR to `main`
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
   - Updates Docker Hub repository description if README.md was modified

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

1. **Builds all image variants** (17 different combinations):
   - Version 1.0: `1_0_a-voron`, `1_0_a_va-voron`, `1_0_a_va_loc-voron`
   - Version 1.2: `1_2_c-voron`, `1_2_c_nodelay-voron`, `1_2_c_nodelay_va_loc-voron`, `1_2_c_patch_va_loc-voron`
   - Version 1.3 (voron): `1_3-voron`, `1_3_cracked-voron`, `1_3_nodelay-voron`, `1_3_patch_va_loc-voron`, `1_3_nodelay_va_loc-voron`
   - Version 1.3 (ibuddieat): `1_3-ibuddieat`, `1_3_cracked-ibuddieat`, `1_3_nodelay-ibuddieat`, `1_3_patch_va_loc-ibuddieat`, `1_3_nodelay_va_loc-ibuddieat`

2. **Pushes to Docker Hub** with tags:
   - For **all variants**: Immutable variant-specific tags (e.g., `6.0.0-1_3_nodelay_va_loc-ibuddieat`) and variant tags (e.g., `1_3_nodelay_va_loc-ibuddieat`)
   - For **default variant only** (`1_3_nodelay_va_loc-ibuddieat`): Semver tags (`6.0.0`, `6.0`, `6`) and `latest`

3. **Updates Docker Hub description** from README.md (if modified)

4. **Runs security scans** (Trivy) on all images

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
- Check that commits are on `main` branch
- Verify `.release-please-manifest.json` exists and is valid

### Docker images not publishing

- Check GitHub Actions workflow status
- Verify Docker Hub credentials are configured in repository secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_PASSWORD`
- Verify `RELEASE_PLEASE_TOKEN` secret is configured (see below)
- Ensure release was properly created (not just tagged)
- Check that `build-test-push.yml` workflow was triggered by the release event

### Version not incrementing correctly

- Review commit messages for proper conventional commit format
- Check for `BREAKING CHANGE:` in commit body for major bumps
- Verify `.release-please-manifest.json` has correct current version

## Required Repository Secrets

The release process requires the following GitHub repository secrets:

### DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD

Docker Hub credentials for pushing images and updating repository descriptions.

**Setup:**

1. Go to Settings → Secrets and variables → Actions
2. Add `DOCKERHUB_USERNAME` (your Docker Hub username)
3. Add `DOCKERHUB_PASSWORD` (your Docker Hub access token or password)

**Note:** These credentials are used by both the `build-test-push.yml` workflow (for pushing images) and the `dockerhub-description.yml` workflow (for updating the repository description from README.md).

### RELEASE_PLEASE_TOKEN

Personal Access Token (PAT) to trigger downstream workflows.

**Why needed:** GitHub's `GITHUB_TOKEN` cannot trigger other workflows (security policy to prevent recursive runs). This blocks `build-test-push.yml` from running when releases are created.

**Required scopes:**

- `repo` - Full control of repositories (create releases, commit changes)
- `workflow` - Update GitHub Actions workflows (trigger build-test-push.yml)

**Setup:**

1. Create token: <https://github.com/settings/tokens> → Generate new token (classic)
   - Note: `RELEASE_PLEASE_TOKEN for call-of-duty-2-docker-server`
   - Expiration: 90 days recommended
   - Select scopes: `repo` + `workflow`
   - Generate and copy token

2. Add to repository: Settings → Secrets → Actions → New repository secret
   - Name: `RELEASE_PLEASE_TOKEN`
   - Value: Paste token

3. Verify: Next release should trigger `build-test-push.yml` workflow

**Reference:** <https://docs.github.com/en/actions/concepts/security/github_token>

## Resources

- [Release Please Documentation](https://github.com/googleapis/release-please)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GitHub GITHUB_TOKEN Limitations](https://docs.github.com/en/actions/concepts/security/github_token)
