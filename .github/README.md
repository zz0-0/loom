# Loom CI/CD Setup

This document describes the CI/CD pipeline and development workflow for the Loom project.

## 🚀 CI/CD Pipeline

The project uses GitHub Actions for automated testing, building, and deployment.

### Workflow Overview

The CI pipeline includes the following jobs:

1. **Test** - Runs on Ubuntu with Flutter
   - Code analysis (`flutter analyze`)
   - Code formatting check
   - Unit tests with coverage
   - Coverage reporting to Codecov

2. **Build Linux** - Cross-platform builds
   - Linux desktop build
   - Artifact upload

3. **Build Windows** - Windows builds
   - Windows desktop build
   - Artifact upload

4. **Build macOS** - macOS builds
   - macOS desktop build
   - Artifact upload

5. **Rust Tests** - Native code testing
   - Rust unit tests
   - Code linting
   - Formatting checks

6. **Dependency Check** - Security and maintenance
   - Outdated package detection
   - Security vulnerability scanning

7. **Release** - Automated releases
   - Artifact collection
   - GitHub release creation
   - Release notes generation

## 🛠️ Local Development

### Quality Checks

Before committing code, run the development quality check script:

```bash
./scripts/dev_check.sh
```

This script will:
- Install dependencies
- Run code analysis
- Check formatting
- Run tests
- Check Rust code quality
- Generate test coverage

### Manual Commands

You can also run individual checks:

```bash
# Flutter checks
cd loom
flutter pub get
flutter analyze
flutter format --dry-run --set-exit-if-changed .
flutter test --coverage

# Rust checks
cd rust
cargo test
cargo clippy -- -D warnings
cargo fmt --check
```

## 📊 Code Coverage

Test coverage is automatically generated and uploaded to Codecov on each push to main or develop branches.

- Coverage reports: `coverage/lcov.info`
- Codecov integration for PR comments and status checks

## 🔄 Automated Dependency Updates

Dependabot is configured to automatically create PRs for:
- Flutter packages (weekly)
- Rust crates (weekly)
- GitHub Actions (weekly)

## 🚀 Release Process

Releases are automatically created when code is pushed to the main branch:

1. All tests must pass
2. All builds must succeed
3. Artifacts are collected and archived
4. GitHub release is created with generated release notes

## 📋 Branch Protection

The main branch has the following protections:
- Requires status checks to pass
- Requires up-to-date branches
- Includes administrators in restrictions

## 🔧 Configuration Files

- `.github/workflows/ci.yml` - Main CI workflow
- `.github/dependabot.yml` - Automated dependency updates
- `scripts/dev_check.sh` - Local development quality checks

## 📈 Monitoring

The CI pipeline provides:
- Build status badges
- Test coverage reports
- Automated security scanning
- Cross-platform compatibility verification

## 🤝 Contributing

When contributing:
1. Run `./scripts/dev_check.sh` before committing
2. Ensure all CI checks pass
3. Keep test coverage above 80%
4. Follow the established code formatting
5. Update tests for new features

This setup ensures high code quality, automated testing, and reliable releases for the Loom project.
