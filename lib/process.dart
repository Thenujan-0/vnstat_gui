import 'package:shell/shell.dart';

void main() async {
  String k = '';

  var shell = Shell();
  var data_read = shell.startAndReadAsString('vnstat', arguments: ['-h']);

  RegExp regExp = RegExp(r'\d\d\d\d-\d\d-\d\d');

  String k1 = await data_read;
  // print(k1);
  List<String> lines = k1.split('\n');
  String router_title = lines[1];
  // print(router_title + ' <--title');
  String headings = lines[3];
  // print(headings + '  <--heading');
  List<String> dates = [];
  List<List<String>> hours = [];
  int current_index = -1;

  for (int i = 0; i < lines.length; i++) {
    // print(i);
    // print(lines[i]);
    List<String> words = lines[i].split(' ');

    if (regExp.hasMatch(lines[i])) {
      print('regular expression matcfh  wasw found');
      dates.add(lines[i]);
      hours.add([]);
      current_index++;
    }

    if (words.length > 1) {
      // print(words.length);
      // print(words);
      // print('aboce is words');
      for (int i = 0; i < words.length; i++) {
        // print(i);
        // print('above is i');
        if (words[i] == '') {
          words.remove('');
        }
      }
    }
    // print(words);
    if (words.length > 1) {
      // print(words[1] + '1st index');
    }
    if (words.length > 1 && words[0].length > 1) {
      if (words[0][2] == ":") {
        // print('current index is' + current_index.toString());
        hours[current_index].add(lines[i]);
        // print('yes bro');
      }
    }
  }
  // print(hours.toString() + '<---------------hours list');

  // k = 'sad';
  print(hours);
  print(dates);
  print('_________________-----');
}
