# Releasing

This document describes the steps to release a new version of UDDF Swift.

## Prerequisites

- You have commit access to the repository
- You have push access to the repository

## Release process

1. **Determine the new version**

   ```shell
   VERSION=0.X.0
   ```

2. **Update CHANGELOG.md**

   Move changes from `Unreleased` to a new release section:

   ```markdown
   ## [X.X.X] - YYYY-MM-DD
   ```

   Add entries following Common Changelog format.

3. **Run tests** and confirm they pass

   ```shell
   swift test
   ```

4. **Build** and confirm it compiles

   ```shell
   swift build
   ```

5. **Commit any pending changes**

   ```shell
   git add .
   git commit -m "Description of changes"
   ```

6. **Create a tag**

   ```shell
   git tag v$VERSION
   ```

7. **Push the changes and tag**

   ```shell
   git push origin main
   git push origin v$VERSION
   ```

## Post-release

- Verify the new version appears on [GitHub releases](https://github.com/weppos/uddf-swift/releases)
