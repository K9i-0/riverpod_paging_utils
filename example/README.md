# Riverpod Paging Utils Example

This example app demonstrates various usage patterns of the `riverpod_paging_utils` package.

## Available Examples

### Basic Usage (`main.dart`)
The main example showing basic pagination with ListView using cursor-based pagination.

### UI Customization Examples
- **Basic Customization (`main2.dart`)**: Shows how to customize loading and error views using `PagingHelperViewTheme`
- **Advanced Customization (`main3.dart`)**: Demonstrates integration with custom refresh indicators (e.g., `easy_refresh`)

### Feature Examples (accessible from the drawer menu)
- **First Page Error**: Demonstrates error handling for the initial page load
- **Second Page Error**: Shows error handling for subsequent page loads
- **Passing Args Screen**: Example of passing arguments to the fetch method
- **Paging Method Screen**: Demonstrates different pagination methods (Page, Offset, Cursor)
- **GridView Example**: Shows how to use `PagingHelperView` with `GridView` for paginated grid layouts

## Running the Examples

1. Run the default example:
   ```bash
   flutter run
   ```

2. Run specific examples:
   ```bash
   flutter run -t lib/main2.dart  # Basic UI customization
   flutter run -t lib/main3.dart  # Advanced UI customization
   ```

3. Navigate through different examples using the drawer menu in the main app.
