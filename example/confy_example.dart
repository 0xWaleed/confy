import "dart:io";

import "package:confy/confy.dart";

main() {
  // to load configuration files global and another one based on APP_ENV environment.
  confyLoad(environmentResolver: () => Platform.environment["APP_ENV"]);

  print("name ${confy("NAME")}");
  print("description ${confy("DESC")}");

  int v(chunk) {
    return confy("APP.VERSION.$chunk");
  }

  final appVersion = "${v("MAJOR")}.${v("MINOR")}.${v("PATCH")}";

  print("app version: $appVersion");

  print("key not exist ${confy("MY_SECRET", defaultValue: 123)}");

  // ... your code
}
