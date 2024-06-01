## [0.4.3](https://github.com/K9i-0/riverpod_paging_utils/compare/0.4.2...0.4.3) - 2024-06-01

## 0.4.2

### Miscellaneous
- Add Family Provider sample.

## 0.4.1

### Miscellaneous
- Update Readme.

## 0.4.0

### Features
- Added support for using Riverpod providers with family and keepAlive: true.

## 0.3.1

### Miscellaneous

- Added GIFs to README

## 0.3.0

### Features
- Added a screen for when an error occurs while fetching the second page and beyond.
- You can disable the new error screen by setting `showSecondPageError` to `false`.

### Miscellaneous

- Added an example to `example` that demonstrates the behavior when an error occurs.

## 0.2.0

### Features
- Added PagingHelperViewTheme: Introduced a new ThemeExtension to enable highly customizable styling for the PagingHelperView widget. Developers can now easily tailor the loading, error, and end-of-list views to match their application's design.

```
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

* Initial version.
