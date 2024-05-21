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
