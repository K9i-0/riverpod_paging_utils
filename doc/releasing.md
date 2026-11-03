# Maintenance and release

Maintainers work directly on `main`, commit with Conventional Commits, and push.
PRs remain available for outside contributions and dependency bots. Inspect the
working tree before switching branches; preserve work already in progress.
A main push runs CI and never publishes a version.

## Release procedure

Only perform the following when a release is requested. Maintenance changes do
not imply a version bump or tag. Review the difference since the last published
version and choose the appropriate semantic version. Keep the public SDK floor
unless a compatibility change is intentional.

1. Update `version:` in `pubspec.yaml` and add a `## X.Y.Z` section to
   `CHANGELOG.md` describing the user-visible changes.
2. Run the local checks below using the development SDK specified in AGENTS.md.
   Require all checks to pass; resolve new publish warnings.

```sh
flutter pub get
dart run melos bootstrap
flutter analyze --fatal-infos
sh tool/check_format.sh
flutter test
(cd example && flutter test)
PATROL_DEVICE=<ios-simulator-id> bash tool/patrol_ios.sh
flutter pub publish --dry-run
```

3. Commit the release changes on main and push main first. Inspect CI for that
   exact commit. The tagged revision must already be on `origin/main`.
4. Create and push the package-specific tag:

```sh
git tag riverpod_paging_utils-vX.Y.Z
git push origin riverpod_paging_utils-vX.Y.Z
```

`.github/workflows/publish.yml` validates the package/version/CHANGELOG and main
ancestry, then calls the same CI workflow used by main. The required iOS Patrol
job must pass; a skipped or failed test run cannot authorize publication. Only after those jobs succeed does the publish job obtain
GitHub OIDC credentials, run a dry-run, and publish to pub.dev. Manual
`dart pub publish` / `flutter pub publish` is not the release path.

## Automated publishing configuration

The package's pub.dev Admin settings must authorize repository
`K9i-0/riverpod_paging_utils` and tag pattern `riverpod_paging_utils-v{{version}}`.
No long-lived pub credential is stored in the repository. A workflow file alone
does not enable pub.dev's OIDC trust; check the Admin setting before the first
release with this convention.

## Completion and failure

Watch the tag's Publish workflow and verify pub.dev's `latest.version` matches.
If checks fail, fix the cause; do not bypass the gate. Before correcting a failed
release tag, first verify that version was not already published. Never move a
successful release tag. Once published, fix issues with a new version.

The old numeric tags remain in history. New releases use the package-prefixed
format; tagpr no longer creates release PRs or tags on a main push.
