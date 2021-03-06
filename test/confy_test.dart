import "dart:io";

import "package:confy/confy.dart";
import "package:test/test.dart";

late String confyFileExtension;

testBasicUsage() {
  test("load confy top level key", () {
    confyLoad();
    expect(confy("NAME"), equals("WALEED"));
  });

  test("load confy nested level key", () {
    confyLoad();
    expect(confy("SECRET.TOKEN"), equals("321"));
    expect(confy("SECRET.PLATFORM.OS"), equals("win"));
  });

  test("return null when top level key is not exist", () {
    confyLoad();
    expect(confy("not-exist"), isNull);
  });

  test("return null when nested level key is not exist", () {
    confyLoad();
    expect(confy("top.nested"), isNull);
  });

  test("can provide a default value top level key", () {
    confyLoad();
    expect(confy("not-exist", defaultValue: 99), equals(99));
  });

  test("can provide a default value nested key", () {
    confyLoad();
    expect(confy("not.exist", defaultValue: 99), equals(99));
  });

  test("can reference environment variable", () {
    confyLoad();
    expect(confy("MYPATH"), equals(Platform.environment["PATH"]));
  });

  test("can reference environment variable in nested key", () {
    confyLoad();
    expect(confy("PARENT.MYPATH"), equals(Platform.environment["PATH"]));
  });

  test("return the value if we it has incomplete \${ ", () {
    confyLoad();
    expect(confy("MYPATH_1"), equals("\${PATH"));
  });
}

testSpecificEnvironment() {
  test("can load specific environment confy file", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("NAME"), equals("WALEED"));
  });

  test("load confy nested level key", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("SECRET.KEY"), equals(123));
  });

  test("return null when top level key is not exist", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("not-exist"), isNull);
  });

  test("return null when nested level key is not exist", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("top.nested"), isNull);
  });

  test("can provide a default value top level key", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("not-exist", defaultValue: 99), equals(99));
  });

  test("can provide a default value nested key", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("not.exist", defaultValue: 99), equals(99));
  });

  test("should not throw when environmentResolver return null", () {
    confyLoad(environmentResolver: () => null);
    expect(confy("not.exist", defaultValue: 99), equals(99));
  });

  test("can reference environment variable", () {
    confyLoad();
    expect(confy("MYPATH"), equals(Platform.environment["PATH"]));
  });

  test("can reference environment variable in nested key", () {
    confyLoad();
    expect(confy("PARENT.MYPATH"), equals(Platform.environment["PATH"]));
  });

  test("return the value if we it has incomplete \${ ", () {
    confyLoad();
    expect(confy("MYPATH_1"), equals("\${PATH"));
  });
}

testWhenNoConfyFileExist() {
  test("should not throw when file is not exist", () {
    expect(() => confyLoad(), returnsNormally);
  });
}

testWhenBothFileExist() {
  test("should load both files", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("NAME"), equals("WALEED"));
    expect(confy("SECRET.SEED"), equals("8-8"));
  });

  test("specific file override loaded keys", () {
    confyLoad(environmentResolver: () => "dev");
    expect(confy("SECRET.TOKEN"), equals("444"));
  });
}

testAbilityToSetValueAtRuntime() {
  test("able to set value", () {
    confySet("xx", "yy");
    expect(confy("xx"), equals("yy"));
  });

  test("able to append value", () {
    confySet("parent", {"child": "yy"});
    expect(confy("parent.child"), equals("yy"));
  });
}

main() {
  group(".yaml", () {
    confyFileExtension = "yaml";
    setUpAll(() {
      File(".confy.$confyFileExtension").writeAsStringSync("""
NAME: WALEED
MYPATH: \${PATH}
MYPATH_1: \${PATH
PARENT:
  MYPATH: \${PATH}
SECRET:
  KEY: 123
  TOKEN: "321"
  PLATFORM:
    OS: win
    """);

      File(".confy.dev.$confyFileExtension").writeAsStringSync("""
NAME: WALEED
MYPATH: \${PATH}
MYPATH_1: \${PATH
PARENT:
  MYPATH: \${PATH}
SECRET:
  KEY: 123
  TOKEN: "444"
  SEED: "8-8"
  PLATFORM:
    OS: win
    """);
    });
    group("basic usage", testBasicUsage);
    group("specific environment", testSpecificEnvironment);
    group("when no confy file exist", testWhenNoConfyFileExist);
    group("when both file exist", testWhenBothFileExist);

    tearDownAll(() {
      File(".confy.$confyFileExtension").deleteSync();
      File(".confy.dev.$confyFileExtension").deleteSync();
    });
  });

  group(".yml", () {
    confyFileExtension = "yml";
    setUpAll(() {
      File(".confy.$confyFileExtension").writeAsStringSync("""
NAME: WALEED
MYPATH: \${PATH}
MYPATH_1: \${PATH
PARENT:
  MYPATH: \${PATH}
SECRET:
  KEY: 123
  TOKEN: "321"
  PLATFORM:
    OS: win
    """);

      File(".confy.dev.$confyFileExtension").writeAsStringSync("""
NAME: WALEED
MYPATH: \${PATH}
MYPATH_1: \${PATH
PARENT:
  MYPATH: \${PATH}
SECRET:
  KEY: 123
  TOKEN: "444"
  SEED: "8-8"
  PLATFORM:
    OS: win
    """);
    });
    group("basic usage", testBasicUsage);
    group("specific environment", testSpecificEnvironment);
    group("when no confy file exist", testWhenNoConfyFileExist);
    group("when both file exist", testWhenBothFileExist);

    tearDownAll(() {
      File(".confy.$confyFileExtension").deleteSync();
      File(".confy.dev.$confyFileExtension").deleteSync();
    });
  });

  group("ability to set value", testAbilityToSetValueAtRuntime);
}
