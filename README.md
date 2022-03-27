confy to load YAML based configuration file.

## Features

* Load global configuration file `.confy.yaml` or `.confy.yml`.
* Load specific configuration file conditionally based. `.confy.prod.yml` or `.confy.dev.yml`.

## Usage

1. Add your global configuration `.confy.yml`.
2. Optionally add another envy file to override specific environment keys `.confy.prod.yml`.
3. Load envy as follows.

```dart
import "package:confy/confy.dart";

main() {
  // to load configuration files global and another one based on APP_ENV environment.
  confyLoad(environmentResolver: () => Platform.environment["APP_ENV"]);

  print("name ${confy("NAME")}");
  print("description ${confy("DESC")}");
  print("key not exist ${confy("MY_SECRET", defaultValue: 123)}");
  
  // ... your code
}
```
