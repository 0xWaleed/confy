import "dart:io";

import "package:confy/confy.dart";

main() {
  // to load configuration files global and another one based on APP_ENV environment.
  confyLoad(environmentResolver: () => Platform.environment["APP_ENV"]);

  print("name ${confy("NAME")}");
  print("description ${confy("DESC")}");
  print("environment path: ${confy("PATH")}"); // from System Environment set ./examples/.confy.yml

  final v = confy("APP.VERSION");

  final appVersion = "${v?["MAJOR"]}.${v?["MINOR"]}.${v?["PATCH"]}";

  print("app version: $appVersion");

  print("key not exist ${confy("MY_SECRET", defaultValue: 123)}");

  confySet("NAME", "Edited"); // useful when doing unit testing
  print("name ${confy("NAME")}");
  // ... your code
}
