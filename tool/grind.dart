import 'package:grinder/grinder.dart';
import 'package:k9i_cli/k9i_cli.dart';

void main(List<String> args) {
  // Add tasks from the k9i_cli package.
  addBuildRunnerTask(enableAlias: true);

  grind(args);
}
