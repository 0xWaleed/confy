import "dart:io";

import "package:yaml/yaml.dart";

dynamic _envyObject;

envyLoad() {
  final envyContent = File(".envy.yaml").readAsStringSync();
  _envyObject = loadYaml(envyContent);
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
