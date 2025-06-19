import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

/// Example of how to implement pagination with Riverpod 3.0's @mutation feature.
/// 
/// This is an alternative approach that leverages Riverpod 3.0's new features
/// for better state management of asynchronous operations.
///
/// Example usage:
/// ```dart
/// @riverpod
/// class PostsNotifier extends _$PostsNotifier {
///   @override
///   Future<PagePagingData<Post>> build() async {
///     return _fetchPage(1);
///   }
///   
///   @mutation
///   Future<void> loadNextPage() async {
///     final currentState = await future;
///     if (!currentState.hasMore) return;
///     
///     final nextPage = await _fetchPage(currentState.page + 1);
///     
///     if (!ref.mounted) return;
///     
///     state = AsyncData(currentState.copyWith(
///       items: [...currentState.items, ...nextPage.items],
///       page: nextPage.page,
///       hasMore: nextPage.hasMore,
///     ));
///   }
///   
///   Future<PagePagingData<Post>> _fetchPage(int page) async {
///     final response = await api.getPosts(page: page);
///     return PagePagingData(
///       items: response.items,
///       page: page,
///       hasMore: response.hasMore,
///     );
///   }
/// }
/// ```
abstract class PagingNotifierV3<D extends PagingData<T>, T> {
  AsyncValue<D> get state;
  Ref<AsyncValue<D>> get ref;
  
  /// The future representation of the current state for easier async operations
  Future<D> get future => state.future;
  
  /// Checks if provider is still mounted (Riverpod 3.0 feature)
  bool get mounted => ref.mounted;
  
  /// Template method for fetching paginated data
  /// Subclasses should implement this method for their specific pagination logic
  Future<D> fetchData();
  
  /// Common pattern for safe state updates
  void updateState(D Function(D current) update) {
    state.whenData((current) {
      if (!mounted) return;
      state = AsyncData(update(current));
    });
  }
  
  /// Common pattern for handling errors while preserving previous data
  void setError(Object error, StackTrace stackTrace) {
    if (!mounted) return;
    state = AsyncError<D>(error, stackTrace).copyWithPrevious(state);
  }
}

/// Base class for page-based pagination with Riverpod 3.0
abstract class PagePagingNotifierV3<T> 
    extends PagingNotifierV3<PagePagingData<T>, T> {
  
  /// Fetches data for a specific page
  Future<PagePagingData<T>> fetchPage(int page);
  
  @override
  Future<PagePagingData<T>> fetchData() => fetchPage(1);
  
  /// Loads the next page with automatic state management
  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    
    // Prevent duplicate requests
    if (state.isLoading && state.hasValue) return;
    
    // Show loading indicator while keeping previous data
    state = AsyncLoading<PagePagingData<T>>().copyWithPrevious(state);
    
    try {
      final nextData = await fetchPage(current.page + 1);
      
      if (!mounted) return;
      
      updateState((current) => current.copyWith(
        items: [...current.items, ...nextData.items],
        page: nextData.page,
        hasMore: nextData.hasMore,
      ));
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}

/// Base class for offset-based pagination with Riverpod 3.0
abstract class OffsetPagingNotifierV3<T> 
    extends PagingNotifierV3<OffsetPagingData<T>, T> {
  
  /// Fetches data for a specific offset
  Future<OffsetPagingData<T>> fetchOffset(int offset);
  
  @override
  Future<OffsetPagingData<T>> fetchData() => fetchOffset(0);
  
  /// Loads the next batch with automatic state management
  Future<void> loadNext() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    
    // Prevent duplicate requests
    if (state.isLoading && state.hasValue) return;
    
    // Show loading indicator while keeping previous data
    state = AsyncLoading<OffsetPagingData<T>>().copyWithPrevious(state);
    
    try {
      final nextData = await fetchOffset(current.offset);
      
      if (!mounted) return;
      
      updateState((current) => current.copyWith(
        items: [...current.items, ...nextData.items],
        offset: nextData.offset,
        hasMore: nextData.hasMore,
      ));
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}

/// Base class for cursor-based pagination with Riverpod 3.0
abstract class CursorPagingNotifierV3<T> 
    extends PagingNotifierV3<CursorPagingData<T>, T> {
  
  /// Fetches data for a specific cursor
  Future<CursorPagingData<T>> fetchCursor(String? cursor);
  
  @override
  Future<CursorPagingData<T>> fetchData() => fetchCursor(null);
  
  /// Loads the next batch with automatic state management
  Future<void> loadNext() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    
    // Prevent duplicate requests
    if (state.isLoading && state.hasValue) return;
    
    // Show loading indicator while keeping previous data
    state = AsyncLoading<CursorPagingData<T>>().copyWithPrevious(state);
    
    try {
      final nextData = await fetchCursor(current.nextCursor);
      
      if (!mounted) return;
      
      updateState((current) => current.copyWith(
        items: [...current.items, ...nextData.items],
        nextCursor: nextData.nextCursor,
        hasMore: nextData.hasMore,
      ));
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}