import 'package:html/parser.dart';

String stripHTML(String data) {
  final document = parse(data);
  final String parsedString = parse(data).documentElement!.text;
  return parsedString;
}
