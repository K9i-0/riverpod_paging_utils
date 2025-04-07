## [0.8.0](https://github.com/K9i-0/riverpod_paging_utils/compare/0.7.0...0.8.0) - 2025-04-07

- add: melos by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/33>
- improve: update packages by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/40>

## [0.7.0](https://github.com/K9i-0/riverpod_paging_utils/compare/0.6.1...0.7.0) - 2024-06-15

- Refactor!: Ensure endItemView is non-null by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/29>
- refactor: class modifier by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/31>
- Chore: new sample by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/32>

## [0.6.1](https://github.com/K9i-0/riverpod_paging_utils/compare/0.6.0...0.6.1) - 2024-06-13

- [Refactor]: Refactor CI by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/25>
- [Improve]: add format check and code gen check by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/27>

## [0.6.0](https://github.com/K9i-0/riverpod_paging_utils/compare/0.5.0...0.6.0) - 2024-06-03

- refactor: onRefresh callback by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/21>
- del!: Since we added an error UI on the second page and beyond, we will remove the error display in the Snackbar. by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/23>

## [0.5.0](https://github.com/K9i-0/riverpod_paging_utils/compare/0.4.3...0.5.0) - 2024-06-02

- UI Customization Sample by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/16>
- change lint package by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/18>
- skip unnecessary ci check by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/19>
- add: enableRefreshIndicator and enableErrorSnackBar to PagingHelperVi… by @K9i-0 in <https://github.com/K9i-0/riverpod_paging_utils/pull/20>

## [0.4.3](https://github.com/K9i-0/riverpod_paging_utils/compare/0.4.2...0.4.3) - 2024-06-01

## [0.4.2](https://github.com/K9i-0/riverpod_paging_utils/compare/0.4.1...0.4.2) - 2024-06-01

## 0.4.1

- Update Readme.

## 0.4.0

- Added support for using Riverpod providers with family and keepAlive: true.

## 0.3.1

- Added GIFs to README

## 0.3.0

- Added a screen for when an error occurs while fetching the second page and beyond.
- You can disable the new error screen by setting `showSecondPageError` to `false`.
- Added an example to `example` that demonstrates the behavior when an error occurs.

## 0.2.0

- Added PagingHelperViewTheme: Introduced a new ThemeExtension to enable highly customizable styling for the PagingHelperView widget. Developers can now easily tailor the loading, error, and end-of-list views to match their application's design.

```dart
ThemeData(
  extensions: [
    PagingHelperViewTheme(
      loadingViewBuilder: (context) => CircularProgressIndicator(),
      // ... other customizations
    ),
  ],
  // ... rest of your theme
)
```

## 0.1.0

- Initial version.
