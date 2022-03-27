import "dart:io";

import "package:yaml/yaml.dart";

dynamic _envyObject = {};

typedef EnvironmentResolverFunction = String? Function();

final files = [".envy", ".envy.%s"];
final extensions = ["yaml", "yml"];

_loadEnvy(envyFile) {
  String? file;
  for (final ext in extensions) {
    var temp = "$envyFile.$ext";
    if (File(temp).existsSync()) {
      file = temp;
      break;
    }
  }

  if (file == null) {
    return;
  }

  final envyContent = File(file).readAsStringSync();
  final envyContentAsYaml = loadYaml(envyContent);
  _envyObject = {..._envyObject as Map, ...envyContentAsYaml};
}

envyLoad({EnvironmentResolverFunction? environmentResolver}) {
  for (final file in files) {
    if (file.contains("%s") && environmentResolver != null) {
      String? environment = environmentResolver();
      if (environment != null) _loadEnvy(file.replaceFirst("%s", environment));
      continue;
    }
    _loadEnvy(file);
  }
}

T? envy<T>(String key, {T? defaultValue}) {
  var envyObjectPointer = _envyObject;
  final keys = key.split(".");
  for (var key in keys) {
    envyObjectPointer = envyObjectPointer[key];
    if (envyObjectPointer == null) {
      return defaultValue;
    }
  }
  return envyObjectPointer;
}
