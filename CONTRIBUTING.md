# Contributing to ruby-jq

Thank you for your interest in contributing to ruby-jq! This document provides guidelines and instructions for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your changes
4. Make your changes
5. Test your changes
6. Submit a pull request

## Development Setup

### Prerequisites

- Ruby
- jq library dependencies (see README.md)

### Installing Dependencies

```bash
bundle install
```

### Running Tests

```bash
bundle exec rspec
```

## Changelog Management

This project uses [Changie](https://changie.dev/) to manage changelog entries. This helps us maintain a clear and consistent changelog across releases.

### Installing Changie

#### macOS

```bash
brew tap miniscruff/changie https://github.com/miniscruff/changie
brew install changie
```

#### Linux/Windows

Download the appropriate binary from the [Changie releases page](https://github.com/miniscruff/changie/releases).

#### Go Install

```bash
go install github.com/miniscruff/changie@latest
```

### Adding a Changelog Entry

When you make a change that should be noted in the changelog, create a new changelog entry:

```bash
changie new
```

This will prompt you to:
1. Select the type of change (Added, Changed, Deprecated, Removed, Fixed, Security)
2. Enter a description of your change
3. Optionally provide a GitHub issue number

The command will create a new file in `.changes/unreleased/` with your changelog entry.

### Types of Changes

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes

### When to Add a Changelog Entry

Add a changelog entry for:
- New features
- Bug fixes
- Breaking changes
- Deprecations
- Security fixes
- Significant performance improvements

You may skip a changelog entry for:
- Documentation updates (typos, clarifications)
- Internal refactoring with no user-facing changes
- Test updates
- CI/CD configuration changes

## Pull Request Guidelines

1. Follow the existing code style
2. Add tests for new functionality
3. Update documentation as needed
4. **Add a changelog entry using `changie new`**
5. Ensure all tests pass
6. Fill out the pull request template completely

## Code Style

Please follow the existing code style in the project. We use RuboCop for Ruby code style enforcement.

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.

## License

By contributing to ruby-jq, you agree that your contributions will be licensed under the same license as the project (see LICENSE.txt).
