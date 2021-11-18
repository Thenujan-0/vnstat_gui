import 'package:flutter/material.dart';
import 'package:shell/shell.dart';
import 'process.dart' as process;

class DateHeading {
  late String date;
  late List lines;
  late List children;
  DateHeading(this.date, this.lines);
}

class HourLine {
  late String hour;
  late String download;
  late String upload;
  late String total;
  late String averageRate;

  HourLine(
      this.hour, this.download, this.upload, this.total, this.averageRate) {}
}

List<DateHeading> dateHeadingObjs = [];

List<HourLine> hourLineObjs = [];

void main() {
  runApp(const MyApp());
}

var vnstat_data = 'not yet';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter not Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vnstat GUI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: UsageHourly2(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('final_string below ');
          // print(final_string);
          setState(() {});
        },
        tooltip: 'does nothing',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UsageHourlyTable extends StatefulWidget {
  const UsageHourlyTable({Key? key}) : super(key: key);

  @override
  _UsageHourlyTableState createState() => _UsageHourlyTableState();
}

List<TableRow> children_usage_hourly = [];
String routerTitle = 'unknown';

class _UsageHourlyTableState extends State<UsageHourlyTable> {
  @override
  initState() {
    vnstat_hourly();

    // runner();
    super.initState();
  }

  vnstat_hourly() async {
    String k = '';

    var shell = Shell();
    var data_read = shell.startAndReadAsString('vnstat', arguments: ['-h']);
    //Regular Expression to find the date
    RegExp regExp = RegExp(r'\d\d\d\d-\d\d-\d\d');
    RegExp date = RegExp(r'\d\d\d\d-\d\d-\d\d');
    RegExp time = RegExp(r'\d\d:\d\d');

    String k1 = await data_read;
    Iterable dates_ = date.allMatches(k1);

    List<String> lines = k1.split('\n');
    String router_title = lines[1];
    // print(router_title + ' <--title');
    String headings = lines[3];
    // print(headings + '  <--heading');
    List<String> dates = [];
    List<List<String>> hours = [];
    int current_index = -1;

    for (int i = 0; i < lines.length; i++) {
      List<String> words = lines[i].split(' ');
      //trying to find the date
      if (regExp.hasMatch(lines[i])) {
        print('regular expression match for date was found');
        dates.add(lines[i]);
        // print('Elow');
        dateHeadingObjs.add(DateHeading(
            regExp.firstMatch(lines[i])?.group(0) ?? "unknown", []));
        hours.add([]);
        current_index++;
      }

      if (words.length > 1) {
        //removing '' strings from List
        for (int i = 0; i < words.length; i++) {
          // print(i);
          // print('above is i');
          if (words[i] == '') {
            words.remove('');
          }
        }
      }

      if (words.length > 1 && words[0].length > 1) {
        if (words[0][2] == ":") {
          // print('current index is' + current_index.toString());
          hours[current_index].add(lines[i]);

          //addes the following hour lines to the last dateHeading object in the list
          dateHeadingObjs.last.lines.add(lines[i]);
          // print('yes bro');
        }
      }
      //hour is actualy hour lines
      //So lets split this into words

      //this list contains lists that contain lists of times
      //[[an example time , an example time2],[an example time1 , an example time 2 which belogs to another date]]
      List<List> hourList = [];

      //allows us to reach the list of specific date
      // for (int i = 0; i < hours.length + 1; i++) {
      //   //allows me to reach a line in the list
      //   hourList.add([]);
      //   for (int j = 0; j < hours[i].length; j++) {
      //     // hourList[i][j]

      //   }
      // }
    }
    // print(dateHeadingObjs);
    setState(() {
      routerTitle = router_title;
      vnstat_data = 'None';
      children_usage_hourly = [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('date & time', textScaleFactor: 1.5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('download', textScaleFactor: 1.5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('upload', textScaleFactor: 1.5),
          )
        ]),
      ];

      for (int i = 0; i < dateHeadingObjs[0].lines.length; i++) {
        // print(i);
        // print(dateHeadingObjs[0].lines[i]);
        List splited_line = dateHeadingObjs[0].lines[i].split(' ');

        // Now lets remove the empty string from the list
        // int lengthBefore = splited_line
        int emptyStrings = 0;
        for (int i = 0; i < splited_line.length; i++) {
          // print('number of elements in the splited line' +
          // splited_line.length.toString());
          // print('i is now in empty string clearing in line -->' + i.toString());
          if (splited_line[i] == '') {
            // splited_line.remove('');
            emptyStrings++;
            print('counted an empty string');
          }
        }
        for (int i = 0; i < emptyStrings; i++) {
          splited_line.remove('');
        }

        children_usage_hourly.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dateHeadingObjs[0].date + '   ' + splited_line.elementAt(0),
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                splited_line.elementAt(1) + ' ' + splited_line.elementAt(2),
                textScaleFactor: 1.5),
          ),
          //3rd element is '|' symbol
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                splited_line.elementAt(4) + ' ' + splited_line.elementAt(5),
                textScaleFactor: 1.5),
          )
        ]));
      }
    });

    // return final_string;
  }

  void runner() {
    setState(() {
      vnstat_data = vnstat_data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width_app = MediaQuery.of(context).size.width;
    var height_app = MediaQuery.of(context).size.height;
    bool testing = false;
    print(width_app);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Showing data for $routerTitle', textScaleFactor: 2),
      ),
      Container(
        decoration: testing
            ? BoxDecoration(color: Colors.yellow)
            : BoxDecoration(color: Colors.black12),
        constraints: BoxConstraints(
          maxWidth: width_app > 500 ? width_app * 0.6 : 500,
        ),
        child:
            Table(border: TableBorder.all(), children: children_usage_hourly),
      )
    ]);
  }
}

class UsageHourly2 extends StatefulWidget {
  const UsageHourly2({Key? key}) : super(key: key);

  @override
  _UsageHourly2State createState() => _UsageHourly2State();
}

class _UsageHourly2State extends State<UsageHourly2> {
  List<DataRow> dataRows = [];
  String VnstatArg = 'h';

  void buildTableElements() {}

  @override
  initState() {
    vnstat_hourly();

    // runner();
    super.initState();
  }

  Widget getFirstColumn() {
    print('getFirstColumn was called');
    if (VnstatArg == 'h') {
      return Text('date & time');
    } else if (VnstatArg == 'd') {
      return Text('date');
    } else if (VnstatArg == 'm') {
      return Text('month');
    } else {
      return Text('unknown');
    }
  }

  vnstat_hourly() async {
    String k = '';

    var shell = Shell();
    print('gonna talk to vnstat arg is $VnstatArg');
    var data_read =
        shell.startAndReadAsString('vnstat', arguments: ['-$VnstatArg']);
    //Regular Expression to find the date
    RegExp regExp = RegExp(r'\d\d\d\d-\d\d-\d\d');
    RegExp date = RegExp(r'\d\d\d\d-\d\d-\d\d');
    RegExp time = RegExp(r'\d\d:\d\d');
    RegExp monthReg = RegExp(r'\d\d\d\d-\d\d');

    String k1 = await data_read;
    Iterable dates_ = date.allMatches(k1);

    List<String> monthLines = [];

    List<String> lines = k1.split('\n');
    // print(lines);
    String router_title = lines[1];
    // print(router_title + ' <--title');
    String headings = lines[3];
    // print(headings + '  <--heading');
    List<String> dates = [];
    List<List<String>> hours = [];
    int current_index = -1;
    dateHeadingObjs = [];
    for (int i = 0; i < lines.length; i++) {
      List<String> words = lines[i].split(' ');

      if (VnstatArg == 'd' || VnstatArg == 'h') {
        //trying to find the date
        if (regExp.hasMatch(lines[i])) {
          print('regular expression match for date was found');
          dates.add(lines[i]);

          if (dateHeadingObjs.length > 0 &&
              dateHeadingObjs.last.lines.isEmpty) {
            dateHeadingObjs.last.lines.add(lines[i - 1]);
          }
          dateHeadingObjs.add(DateHeading(
              regExp.firstMatch(lines[i])?.group(0) ?? "unknown", []));
          hours.add([]);
          current_index++;
        }

        if (words.length > 1) {
          //removing '' strings from List
          for (int i = 0; i < words.length; i++) {
            // print(i);
            // print('above is i');
            if (words[i] == '') {
              words.remove('');
            }
          }
        }

        if (words.length > 1 && words[0].length > 1) {
          if (words[0][2] == ":") {
            // print('current index is' + current_index.toString());
            hours[current_index].add(lines[i]);

            //addes the following hour lines to the last dateHeading object in the list
            dateHeadingObjs.last.lines.add(lines[i]);
            // print('yes bro');
          }
        }
        //hour is actualy hour lines
        //So lets split this into words

        //this list contains lists that contain lists of times
        //[[an example time , an example time2],[an example time1 , an example time 2 which belogs to another date]]
        List<List> hourList = [];

        //allows us to reach the list of specific date
        // for (int i = 0; i < hours.length + 1; i++) {
        //   //allows me to reach a line in the list
        //   hourList.add([]);
        //   for (int j = 0; j < hours[i].length; j++) {
        //     // hourList[i][j]

        //   }
        // }
      } //if daily or hourly

      else if (VnstatArg == 'm') {
        if (monthReg.hasMatch(lines[i])) {
          monthLines.add(lines[i]);
        }
      }
    } // for loop that iterates over everylines in the output

    children_usage_hourly = [
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: getFirstColumn(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('download', textScaleFactor: 1.5),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('upload', textScaleFactor: 1.5),
        )
      ]),
    ];

    print(dateHeadingObjs);

    setState(() {
      print('set state inside vnstat_hourly was called');
      print('$router_title');
      routerTitle = router_title;
      vnstat_data = 'None';
      dataRows = [];
      // print(dataRows.length);
      if (VnstatArg == 'h' || VnstatArg == 'd') {
        for (int j = 0; j < dateHeadingObjs.length; j++) {
          // print(dataRows.length.toString() +
          // 'data rows length in every dataheadingobj iteration');
          // print(dateHeadingObjs[j].lines.isEmpty
          //     ? 'empty list'
          //     : dateHeadingObjs[j].lines[0] +
          //         ' 5 th line in this data heading obj');

          for (int i = 0; i < dateHeadingObjs[j].lines.length; i++) {
            // print(i);
            // print(dateHeadingObjs[j].lines[i]);
            List splited_line = dateHeadingObjs[j].lines[i].split(' ');

            // Now lets remove the empty string from the list
            // int lengthBefore = splited_line
            int emptyStrings = 0;
            for (int i = 0; i < splited_line.length; i++) {
              // print('number of elements in the splited line' +
              // splited_line.length.toString());
              // print(
              // 'i is now in empty string clearing in line -->' + i.toString());
              if (splited_line[i] == '') {
                // splited_line.remove('');
                emptyStrings++;
                // print('counted an empty string');
              }
            }
            for (int i = 0; i < emptyStrings; i++) {
              splited_line.remove('');
            }
            // print(splited_line);
            dataRows.add(DataRow(cells: [
              DataCell(VnstatArg == 'h'
                  ? Text(dateHeadingObjs[0].date +
                      '   ' +
                      splited_line.elementAt(0))
                  : Text(splited_line.elementAt(0))),
              DataCell(Text(
                  splited_line.elementAt(1) + ' ' + splited_line.elementAt(2))),
              DataCell(Text(
                  splited_line.elementAt(4) + ' ' + splited_line.elementAt(5)))
            ]));
          } //for loop that iterates over lines

          // else if(VnstatArg=='d'){}
        }
        //for loop that iterates over DateHeadingObjs
      } //If statement that checks if it is hourly or daily
      else if (VnstatArg == 'm') {
        dataRows = [];
        // splitted_Line
        for (int i = 0; i < monthLines.length; i++) {
          List splited_line = monthLines[i].split(' ');

          int emptyElementsCount = 0;
          //clear empty elements in monthLines
          for (int j = 0; j < splited_line.length; j++) {
            if (splited_line.elementAt(j) == '') {
              emptyElementsCount++;
            }
          }
          for (int k = 0; k < emptyElementsCount; k++) {
            splited_line.remove('');
          }

          dataRows.add(DataRow(cells: [
            DataCell(VnstatArg == 'h'
                ? Text(
                    dateHeadingObjs[0].date + '   ' + splited_line.elementAt(0))
                : Text(splited_line.elementAt(0))),
            DataCell(Text(
                splited_line.elementAt(1) + ' ' + splited_line.elementAt(2))),
            DataCell(Text(
                splited_line.elementAt(4) + ' ' + splited_line.elementAt(5)))
          ]));
        }
      }
      print(dataRows[0].cells[0].child);
    });

    // return final_string;
  }

  void runner() {
    setState(() {
      vnstat_data = vnstat_data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width_app = MediaQuery.of(context).size.width;
    var height_app = MediaQuery.of(context).size.height;
    List<String> columnNames = ['date and time', 'download', 'upload'];
    bool testing = false;
    print(width_app);
    return SingleChildScrollView(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      scrollDirection: Axis.vertical,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                child: Text('hours'),
                onPressed: () {
                  setState(() {
                    VnstatArg = 'h';
                    vnstat_hourly();

                    dataRows = dataRows;
                  });
                }),
            TextButton(
                child: Text('dates'),
                onPressed: () {
                  setState(() {
                    VnstatArg = 'd';
                    vnstat_hourly();

                    dataRows = dataRows;
                  });
                }),
            TextButton(
                child: Text('months'),
                onPressed: () {
                  setState(() {
                    VnstatArg = 'm';
                    vnstat_hourly();

                    dataRows = dataRows;
                  });
                })
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Showing data for $routerTitle', textScaleFactor: 2),
        ),
        Container(
          decoration: testing
              ? BoxDecoration(color: Colors.yellow)
              : BoxDecoration(color: Colors.black12),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: width_app > 500 ? width_app * 0.6 : 500,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: getColumns(columnNames),
              rows: dataRows,
            ),
          ),
        )
      ]),
    );
  }

  List<DataColumn> getColumns(List<String> columnNames) {
    return columnNames.map((String column) {
      if (column == 'date and time') {
        return DataColumn(label: getFirstColumn());
      } else {
        return DataColumn(label: Text(column));
      }
    }).toList();
  }
}
