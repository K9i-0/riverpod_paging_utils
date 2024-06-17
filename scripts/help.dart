import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final melosFile = File('melos.yaml');
  if (!melosFile.existsSync()) {
    fail('Required files not found.');
  }

  final melosFileString = melosFile.readAsStringSync();

  final yaml = loadYaml(melosFileString) as YamlMap;
  final scripts = yaml['scripts'] as YamlMap;

  log('Available scripts:');
  for (final script in scripts.entries) {
    log('${script.key}');
    final scriptValue = script.value as YamlMap;
    if (scriptValue['description'] != null) {
      log('  ${scriptValue['description']}');
    }
  }
}
