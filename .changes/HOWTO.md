# How to Use Changie in ruby-jq

This guide explains how to use Changie for changelog management in the ruby-jq project.

## For Contributors

### Adding a Changelog Entry

When you make a change that should be documented, create a changelog entry:

```bash
changie new
```

Follow the prompts:
1. **Select kind**: Choose the type of change (Added, Changed, Fixed, etc.)
2. **Enter body**: Describe your change in a clear, user-facing way
3. **GitHub Issue**: Optionally link to an issue number

Example:
```
? Kind: Fixed
? Body: Fix memory leak in JQ parser initialization
? GitHub Issue (optional): 123
```

This creates a file like `.changes/unreleased/20231125_123456.yaml` that will be included in your PR.

### Types of Changes

- **Added**: New features or functionality
- **Changed**: Changes to existing functionality
- **Deprecated**: Features that will be removed in the future
- **Removed**: Features that have been removed
- **Fixed**: Bug fixes
- **Security**: Security-related fixes

### When to Add an Entry

**DO add an entry for:**
- New features
- Bug fixes
- Breaking changes
- API changes
- Security fixes
- Performance improvements

**DON'T add an entry for:**
- Documentation typo fixes
- Internal refactoring with no user impact
- Test changes
- CI/CD configuration updates

## For Maintainers

### Creating a Release

When you're ready to release a new version:

1. **Batch unreleased changes** into a version:
   ```bash
   changie batch v1.2.3
   ```
   This moves all `.changes/unreleased/*.yaml` files into `.changes/v1.2.3.md`

2. **Merge into CHANGELOG.md**:
   ```bash
   changie merge
   ```
   This updates the main CHANGELOG.md file with the new version

3. **Commit the changes**:
   ```bash
   git add .changes/ CHANGELOG.md
   git commit -m "Release v1.2.3"
   ```

4. **Tag and push**:
   ```bash
   git tag v1.2.3
   git push origin main --tags
   ```

### Automatic Version Bumping

Changie can suggest version bumps based on change types:

```bash
changie next
```

This will suggest the next version based on:
- **major**: if any "Removed" changes
- **minor**: if any "Added", "Changed", or "Deprecated" changes
- **patch**: if only "Fixed" or "Security" changes

### Viewing Unreleased Changes

To see what changes are pending release:

```bash
changie latest
```

Or manually check `.changes/unreleased/` directory.

## Configuration

The Changie configuration is in `.changie.yaml`. Key settings:

- `changesDir`: `.changes` - Where changelog fragments are stored
- `unreleasedDir`: `unreleased` - Subdirectory for unreleased changes
- `changelogPath`: `CHANGELOG.md` - Main changelog file
- `kinds`: List of change types and their version bump semantics

## Troubleshooting

### Changie not found

Install Changie:
```bash
# macOS
brew install miniscruff/changie/changie

# Go
go install github.com/miniscruff/changie@latest
```

### Changes not showing up

Make sure you:
1. Created the change file using `changie new`
2. Committed the file in `.changes/unreleased/`
3. Included it in your PR

### Merge conflicts in CHANGELOG.md

This shouldn't happen with Changie! Individual change files prevent conflicts. If you do get a conflict, it's likely in the version headers. Resolve manually and ensure the format matches existing versions.

## Resources

- [Changie Documentation](https://changie.dev/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
