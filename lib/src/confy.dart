import "dart:io";

import "package:yaml/yaml.dart";

dynamic _confyObject = {};

typedef EnvironmentResolverFunction = String? Function();

final files = [".confy", ".confy.%s"];
final extensions = ["yaml", "yml"];

// void _replaceEnvironmentValue(Map entries, [int increment = 0]) {
//   for (final entry in entries.entries) {
//
//     if (entry.value is YamlMap) {
//       _replaceEnvironmentValue(entry.value, ++increment);
//       return;
//     }
//
//     if (entry.value is! String) {
//       continue;
//     }
//
//     String value = entry.value;
//     if (value.startsWith("\$")) {
//       String realValue = value.replaceFirst("\${", "").replaceFirst("}", "");
//       String realEnvValue = value.replaceFirst(entry.value, Platform.environment[realValue] ?? "");
//       entries.update(entry.key, (value) => realEnvValue);
//     }
//   }
// }

_loadConfy(confyFile) {
  String? file;
  for (final ext in extensions) {
    var temp = "$confyFile.$ext";
    if (File(temp).existsSync()) {
      file = temp;
      break;
    }
  }

  if (file == null) {
    return;
  }

  var confyContent = File(file).readAsStringSync();
  confyContent = confyContent.replaceAllMapped(RegExp(r"\$\{(\w+)\}"), (match) {
    final actual = match.group(1);
    return Platform.environment[actual] ?? "";
  });
  final confyContentAsYaml = loadYaml(confyContent);
  _confyObject = {..._confyObject as Map, ...confyContentAsYaml};
}

confyLoad({EnvironmentResolverFunction? environmentResolver}) {
  for (final file in files) {
    if (file.contains("%s") && environmentResolver != null) {
      String? environment = environmentResolver();
      if (environment != null) _loadConfy(file.replaceFirst("%s", environment));
      continue;
    }
    _loadConfy(file);
  }
}

T? confy<T>(String key, {T? defaultValue}) {
  var confyObjectPointer = _confyObject;
  final keys = key.split(".");
  for (var key in keys) {
    confyObjectPointer = confyObjectPointer[key];
    if (confyObjectPointer == null) {
      return defaultValue;
    }
  }
  return confyObjectPointer;
}
