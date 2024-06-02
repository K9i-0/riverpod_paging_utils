import 'package:example/data/sample_item.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:record_iterable_utils/record_iterable_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sample_repository.g.dart';

@riverpod
SampleRepository sampleRepository(SampleRepositoryRef ref) =>
    SampleRepository();

class SampleRepository {
  Future<(List<SampleItem> items, String? nextCursor)> getByCursor(
    String? cursor,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final items = _db
        .sublist(
          int.parse(cursor ?? '0'),
          int.parse(cursor ?? '0') + 30,
        )
        .mapRecord(
          (id, name) => SampleItem(id: id.toString(), name: name),
        )
        .toList();

    final nextCursor = (int.parse(cursor ?? '0') + 30).toString();
    final exist = _db.length > int.parse(nextCursor);

    return (
      items,
      exist ? nextCursor : null,
    );
  }

  Future<(List<SampleItem> items, String? nextCursor)> getByCursorAndId(
    String id,
    String? cursor,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final items = _db
        .sublist(
          int.parse(cursor ?? '0'),
          int.parse(cursor ?? '0') + 30,
        )
        .mapRecord(
          (id, name) => SampleItem(id: id.toString(), name: name),
        )
        .toList();

    final nextCursor = (int.parse(cursor ?? '0') + 30).toString();
    final exist = _db.length > int.parse(nextCursor);

    return (
      items,
      exist ? nextCursor : null,
    );
  }
}

final _randomNames = RandomNames(Zone.us);

final _db = List.generate(
  150,
  (index) => (index + 1, _randomNames.fullName()),
);
