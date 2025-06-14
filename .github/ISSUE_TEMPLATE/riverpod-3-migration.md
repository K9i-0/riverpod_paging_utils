---
name: Riverpod 3.0 Migration Checklist
about: Track progress of Riverpod 3.0 migration
title: '[Migration] Riverpod 3.0 - '
labels: enhancement, migration
assignees: ''

---

## Riverpod 3.0 Migration Checklist

This issue tracks the progress of migrating `riverpod_paging_utils` to Riverpod 3.0.

### Overview
- [ ] Migration plan documented
- [ ] PR strategy defined (8 PRs)
- [ ] Timeline established (4 weeks)

### PR Progress

#### Week 1
- [ ] PR #1: Migration documentation (`feat/riverpod-3-migration-docs`)
  - [ ] Create migration plan document
  - [ ] Create PR strategy document
  - [ ] Create this checklist template
- [ ] PR #2: Update dependencies (`feat/update-riverpod-3-dev`)
  - [ ] Update to `flutter_riverpod: ^3.0.0-dev.15`
  - [ ] Add dependency overrides
  - [ ] Update version to `0.9.0-dev.1`

#### Week 2
- [ ] PR #3: Code compatibility (`feat/riverpod-3-compatibility`)
  - [ ] Replace AutoDisposeAsyncNotifier with AsyncNotifier
  - [ ] Update provider types
  - [ ] Ensure backward compatibility
- [ ] PR #4: Test updates (`feat/riverpod-3-test-updates`)
  - [ ] Update error handling tests for ProviderException
  - [ ] Add automatic retry tests
  - [ ] Improve test coverage

#### Week 3
- [ ] PR #5: Example app update (`feat/riverpod-3-example-update`)
  - [ ] Update example code
  - [ ] Update documentation
  - [ ] Test all examples
- [ ] PR #6: Mutation API implementation (`feat/mutation-api-implementation`)
  - [ ] Create mutation-based notifier
  - [ ] Create mutation helper view
  - [ ] Add examples and tests

#### Week 4
- [ ] PR #7: CI/CD updates (`feat/riverpod-3-ci-update`)
  - [ ] Update GitHub Actions workflows
  - [ ] Configure for pre-release publishing
- [ ] PR #8: Release preparation (`feat/riverpod-3-release-prep`)
  - [ ] Final documentation review
  - [ ] Update CHANGELOG
  - [ ] Prepare for v0.9.0-dev.1 release

### Testing
- [ ] All unit tests passing
- [ ] All widget tests passing
- [ ] Example app working correctly
- [ ] Performance benchmarks completed

### Documentation
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] Migration guide published
- [ ] API documentation updated

### Release
- [ ] Pre-release version published to pub.dev
- [ ] Feedback channels established
- [ ] Announcement prepared

### Notes
- This migration is being done as a pre-release to gather feedback
- The Mutation API is experimental and may change
- Maintaining backward compatibility where possible

### Related Links
- [Migration Plan](../../../docs/migration-to-riverpod-3.0.md)
- [PR Strategy](../../../docs/migration-pr-plan.md)
- [Riverpod 3.0 Documentation](https://riverpod.dev/docs/3.0_migration)