import 'dart:io';

/// function to read files as string
String fixture(String name) {
  return File("test/fixtures/$name").readAsStringSync();
}
