import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'loginScreen.dart';
import 'processes.dart';
import 'loginScreen.dart' as log;
import 'styles.dart';
import 'package:flutter_tts/flutter_tts.dart';

// declare global variables
var sensorData = '1';
List<sData> dataArray = [];
var index = 0;
var now, date;
var dirX, dirY, direction, distance;
var leftSensor, rightSensor, midSensor, lidarSensor, splitted;
var newLeft, newRight, newMid, newLidar;
var truePath;

// initialize database
// var db = Mysql();
final FlutterTts tts = FlutterTts();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // keep user logged in
  late SharedPreferences prefdata;
  late String username;

  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  // bool connWebsocket = false;

  // connectivity result variables
  bool hasInternet = false;
  ConnectivityResult connResult = ConnectivityResult.none;

  // get sensor data
  // late bool ledstatus; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  late bool webSocketConnected;

  //boolean value to track if WebSocket is connected

  @override
  void initState() {
    initializeCsv();
    super.initState();
    _sensorData = getSensorData();
    webSocketConnected =
        false; // initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); // connect to WebSocket wth NodeMCU
    });

    // check internet connectivity
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() => this.hasInternet = hasInternet);

      if (this.hasInternet == true) {
        Fluttertoast.showToast(msg: "Connected to the Internet");
        if (log.loggedIn == false) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Not Logged In'),
                    content: const Text('Log in to preserve sensor data'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen())),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        }
        if (webSocketConnected == false) {
          Fluttertoast.showToast(msg: "Preparing to send data to the database");
          transferData(truePath);
        }
      } else {
        Fluttertoast.showToast(msg: "No Internet Connection");
      }
      // calls websocket if connectivity changes
      channelconnect();

      // uploads data to database when disconnected to the websocket and connected to the internet
      // if(connected==false && this.hasInternet==true){
      //   transferData(truePath);
      // }
    });

    initial();

    super.initState();
  }

  void initial() async {
    prefdata = await SharedPreferences.getInstance();
    setState(() {
      username = prefdata.getString('username')!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  channelconnect() {
    // function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      Fluttertoast.showToast(msg: "Connecting to channel...");
      channel.stream.listen(
        (message) {
          print(message);
          sensorData = message;

          // separating received sensor data
          splitted = sensorData.split(',');
          leftSensor = splitted[3];
          rightSensor = splitted[1];
          midSensor = splitted[2];
          lidarSensor = splitted[0];

          // convert sensor data to double
          newLeft = double.parse(leftSensor);
          newRight = double.parse(rightSensor);
          newMid = double.parse(midSensor);
          newLidar = double.parse(lidarSensor);

          // other data based on time and sensor data
          date = DateTime.now();
          now = DateFormat.Hms().format(date);

          // change something here to limit the capacity of the system to treat things as objects
          distance = newLidar;
          direction = getDirection(newLeft, newRight, newMid, newLidar);
          tts.speak(direction);

          // Push sensor data to csv file for offline processes
          //["UserID", "Time", "Distance", "Direction", "Sensor1", "Sensor2", "Sensor3", "LiDAR"]
          if (direction == 'Upper ') {
          } else {
            // pushData();
            data.add([
              log.userId,
              date,
              distance,
              direction,
              newLeft,
              newRight,
              newMid,
              newLidar
            ]);
            generateCsv();

            dataArray.add(sData(now, distance.toString(), direction));

            _time.add(now);
            _distance.add(distance.toString());
            _direction.add(direction);

            setState(() {
              dataArray.toSet();
              dataArray.toList();
            });
          }
        },
        onDone: () {
          // if WebSocket is disconnected
          Fluttertoast.showToast(msg: "Web socket is closed");
          setState(() {
            webSocketConnected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      Fluttertoast.showToast(msg: "error on connecting to websocket");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (webSocketConnected == true) {
      Fluttertoast.showToast(msg: "Connected to the Websocket");
    } else {
      channelconnect();
      Fluttertoast.showToast(msg: "Websocket is not connected.");
    }
  }

  // system ui
  Widget buildLogoutBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          prefdata.setBool('login', true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const log.LoginScreen()),
              (route) => false);
        },
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.green.shade900,
        child: const Text(
          'Logout',
          style: btnStyle,
        ),
      ),
    );
  }

  Widget buildUpload() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          transferData(truePath);
        },
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.green.shade900,
        child: const Text(
          'Upload',
          style: btnStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Komori',
          style: headerStyle,
        ),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Activity Log',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    backgroundColor: Colors.grey.shade900,
                    appBar: AppBar(
                      title: const Text(
                        'User Activity Log',
                        style: headerStyle,
                      ),
                      backgroundColor: Colors.green.shade900,
                    ),
                    body: Column(
                      //User Activity Log
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '$username',
                          textAlign: TextAlign.center,
                          style: profileUserStyle,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'User ID: ${log.userId}',
                          textAlign: TextAlign.center,
                          style: profileIdStyle,
                        ),
                        const SizedBox(height: 5),
                        buildUpload(),
                        const SizedBox(height: 5),
                        buildLogoutBtn(),
                        const Divider(
                          height: 25,
                          color: Colors.white,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Expanded(
                            child: Padding(
                          //flex: 1,
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: Colors.cyan,
                            ),
                            child: dataGrid(context),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                        )
                            //padding: EdgeInsets.only(left: 10),
                            ),
                      ],
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(100.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(1),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(80.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.75),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(60.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
            Center(
              child: Image.asset(
                'assets/phone-vibrate.png',
                width: 60,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    // log.loggedIn.toString() + 'WOKEGE',
                    truePath.toString(),
                    //poggers.toString(),
                    //newData.toString(),
                    //'The sensors are detecting objects. Please wait...',
                    //'Left sensor detected object at ${sensorData} cm.',
                    style: hoverStyle,
                  ),
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 60),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.50),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  width: 375,
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<Null> getRefresh() async {
  await Future.delayed(const Duration(seconds: 3));
}

List<sData> _sensorData = <sData>[];

// create datagrid widget admin version
Widget dataGrid(BuildContext context) {
  return SfDataGrid(
    allowPullToRefresh: true,
    columnWidthMode: (dataArray.isEmpty == false)
        ? ColumnWidthMode.auto
        : ColumnWidthMode.none,
    source: _sensorDataSource,
    frozenColumnsCount: 1,
    isScrollbarAlwaysShown: true,
    columns: <GridColumn>[
      GridColumn(
          columnName: 'time',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Time',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'distance',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Distance',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'direction',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Direction',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
    ],
    gridLinesVisibility: GridLinesVisibility.both,
    headerGridLinesVisibility: GridLinesVisibility.both,
  );
}

SensorDataSource _sensorDataSource = SensorDataSource();

class SensorDataSource extends DataGridSource {
  SensorDataSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'time')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: dataGridDataStyle,
          ));
    }).toList());
  }

  @override
  Future<void> handleRefresh() async {
    await Future.delayed(Duration(seconds: 5));
    _addMoreRows(_sensorData, 10);
    buildDataGridRows();
    notifyListeners();
  }

  void buildDataGridRows() {
    dataGridRows = _sensorData
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'time', value: dataGridRow.time),
              DataGridCell<String>(
                  columnName: 'distance', value: dataGridRow.distance),
              DataGridCell<String>(
                  columnName: 'direction', value: dataGridRow.direction),
            ]))
        .toList();
  }

  void _addMoreRows(List<sData> sensorData, int count) {
    final startIndex = sensorData.isNotEmpty ? sensorData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      sensorData.add(sData(
        _time[index],
        _distance[index],
        _direction[index],
      ));
    }
  }
}

List<String> _time = <String>[];
List<String> _distance = <String>[];
List<String> _direction = <String>[];

class sData {
  sData(this.time, this.distance, this.direction);
  String time;
  String distance;
  String direction;
}

List<sData> getSensorData() {
  return dataArray;
}

// functions for csv data
List<List<dynamic>> data = [
  //["UserID", "Time", "Distance", "Direction", "Sensor1", "Sensor2", "Sensor3", "Sensor4", "LiDAR"]
];

generateCsv() async {
  String csvData = ListToCsvConverter().convert(data);
  final String directory = (await getApplicationSupportDirectory()).path;
  final path = "$directory/data.csv";
  truePath = path;
  final File file = File(path);
  await file.writeAsString(csvData);
  Fluttertoast.showToast(msg: "CSV created");
}

initializeCsv() async {
  List<List<dynamic>> temp = [];
  String csvData = ListToCsvConverter().convert(temp);
  final String directory = (await getApplicationSupportDirectory()).path;
  final path = "$directory/data.csv";
  truePath = path;
  final File file = File(path);
  await file.writeAsString(csvData);
  Fluttertoast.showToast(msg: "CSV created");
}

pushData() {}
