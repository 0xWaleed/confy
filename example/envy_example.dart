import "dart:io";

import "package:envy/envy.dart";

void main() {
  envyLoad(environmentResolver: () => Platform.environment["APP_ENV"]);
  print("name ${envy("NAME")}");
  print("description ${envy("DESC")}");
  print("key not exist ${envy("MY_SECRET", defaultValue: 123)}");
}
