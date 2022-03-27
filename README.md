Envy to load YAML based configuration file.

## Features

* Load global configuration file `.envy.yaml` or `.envy.yml`.
* Load specific configuration file conditionally based. `.envy.prod.yml` or `.envy.dev.yml`.

## Usage

1. Add your global configuration `.envy.yml`.
2. Optionally add another envy file to override specific environment keys `.envy.prod.yml`.
3. Load envy as follows.

```dart
import "package:envy/envy.dart";

main() {
  // to load configuration files global and another one based on APP_ENV environment.
  envyLoad(environmentResolver: () => Platform.environment["APP_ENV"]);
  
  
  print("name ${envy("NAME")}");
  print("description ${envy("DESC")}");
  print("key not exist ${envy("MY_SECRET", defaultValue: 123)}");
  
  // ... your code
}
```
