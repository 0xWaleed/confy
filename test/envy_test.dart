import "dart:io";

import "package:envy/envy.dart";
import "package:test/test.dart";

late String envyFileExtension;

testBasicUsage() {
  test("load envy top level key", () {
    envyLoad();
    expect(envy("NAME"), equals("WALEED"));
  });

  test("load envy nested level key", () {
    envyLoad();
    expect(envy("SECRET.TOKEN"), equals("321"));
  });

  test("return null when top level key is not exist", () {
    envyLoad();
    expect(envy("not-exist"), isNull);
  });

  test("return null when nested level key is not exist", () {
    envyLoad();
    expect(envy("top.nested"), isNull);
  });

  test("can provide a default value top level key", () {
    envyLoad();
    expect(envy("not-exist", defaultValue: 99), equals(99));
  });

  test("can provide a default value nested key", () {
    envyLoad();
    expect(envy("not.exist", defaultValue: 99), equals(99));
  });
}

testSpecificEnvironment() {
  test("can load specific environment envy file", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("NAME"), equals("WALEED"));
  });

  test("load envy nested level key", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("SECRET.KEY"), equals(123));
  });

  test("return null when top level key is not exist", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("not-exist"), isNull);
  });

  test("return null when nested level key is not exist", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("top.nested"), isNull);
  });

  test("can provide a default value top level key", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("not-exist", defaultValue: 99), equals(99));
  });

  test("can provide a default value nested key", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("not.exist", defaultValue: 99), equals(99));
  });

  test("should not throw when environmentResolver return null", () {
    envyLoad(environmentResolver: () => null);
    expect(envy("not.exist", defaultValue: 99), equals(99));
  });
}

testWhenNoEnvyFileExist() {
  test("should not throw when file is not exist", () {
    expect(() => envyLoad(), returnsNormally);
  });
}

testWhenBothFileExist() {
  test("should load both files", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("NAME"), equals("WALEED"));
    expect(envy("SECRET.SEED"), equals("8-8"));
  });

  test("specific file override loaded keys", () {
    envyLoad(environmentResolver: () => "dev");
    expect(envy("SECRET.TOKEN"), equals("444"));
  });
}

main() {
  group(".yaml", () {
    envyFileExtension = "yaml";
    setUpAll(() {
      File(".envy.$envyFileExtension").writeAsStringSync("""
    NAME: WALEED
    SECRET:
      KEY: 123
      TOKEN: "321"
    """);

      File(".envy.dev.$envyFileExtension").writeAsStringSync("""
    NAME: WALEED
    SECRET:
      KEY: 123
      TOKEN: "444"
      SEED: "8-8"
    """);
    });

    group("basic usage", testBasicUsage);
    group("specific environment", testSpecificEnvironment);
    group("when no envy file exist", testWhenNoEnvyFileExist);
    group("when both file exist", testWhenBothFileExist);

    tearDownAll(() {
      File(".envy.$envyFileExtension").deleteSync();
      File(".envy.dev.$envyFileExtension").deleteSync();
    });
  });

  group(".yml", () {
    envyFileExtension = "yml";
    setUpAll(() {
      File(".envy.$envyFileExtension").writeAsStringSync("""
    NAME: WALEED
    SECRET:
      KEY: 123
      TOKEN: "321"
    """);

      File(".envy.dev.$envyFileExtension").writeAsStringSync("""
    NAME: WALEED
    SECRET:
      KEY: 123
      TOKEN: "444"
      SEED: "8-8"
    """);
    });
    group("basic usage", testBasicUsage);
    group("specific environment", testSpecificEnvironment);
    group("when no envy file exist", testWhenNoEnvyFileExist);
    group("when both file exist", testWhenBothFileExist);
    tearDownAll(() {
      File(".envy.$envyFileExtension").deleteSync();
      File(".envy.dev.$envyFileExtension").deleteSync();
    });
  });
}
