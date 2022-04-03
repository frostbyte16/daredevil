import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/divider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/widgets.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'mysql.dart';
import 'processes.dart';
import 'loginScreen.dart' as log;
import 'styles.dart';


// declare global variables
var sensorData = '1';
List<sData> dataArray = [];
var index = 0;
var now, date;
var dirX, dirY, direction, distance;
var leftSensor, rightSensor, upSensor, downSensor, lidarSensor, splitted;
var newLeft, newRight, newUp, newDown, newLidar;
var truePath;

// initialize database
// var db = Mysql();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  // connectivity result variables
  bool hasInternet = false;
  ConnectivityResult connResult = ConnectivityResult.none;

  // get sensor data
  // late bool ledstatus; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  late bool connected; //boolean value to track if WebSocket is connected

  @override
  void initState() {
    initalizeCsv();
    super.initState();
    _sensorData = getSensorData();
    //ledstatus = false; // initially ledstatus is off so its FALSE
    connected = false; // initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero,() async {
      channelconnect(); // connect to WebSocket wth NodeMCU
    });

    super.initState();

    // check internet connectivity
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() => this.hasInternet = hasInternet);

      if(this.hasInternet==true){
        Fluttertoast.showToast(msg: "Connected to the Internet");
        // transferData(truePath);
      } else{
        Fluttertoast.showToast(msg: "No Internet Connection");
      }
      channelconnect();
    });
  }

  @override
  void dispose(){
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  channelconnect(){ // function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      Fluttertoast.showToast(msg: "Connecting to channel...");
      channel.stream.listen((message) {
        print(message);
        sensorData = message;

        // separating received sensor data

        splitted = sensorData.split(',');
        leftSensor = splitted[0];
        rightSensor = splitted[1];
        upSensor = splitted[2];
        downSensor = splitted[3];

        // convert sensor data to double
        newLeft = double.parse(leftSensor);
        newRight = double.parse(rightSensor);
        newUp = double.parse(upSensor);
        newDown = double.parse(downSensor);

        // other data based on time and sensor data
        date = DateTime.now();
        now = "${date.hour}:${date.minute}:${date.second}";

        distance = getDistance(newLeft, newRight);
        direction = getDirection(newLeft, newRight, newUp, newDown);

        // Push sensor data to csv file for offline processes
        //["UserID", "Time", "Distance", "Direction", "Sensor1", "Sensor2", "Sensor3", "Sensor4", "LiDAR"]
        data.add([log.userId,now,distance,direction, newLeft, newRight, newUp, newDown, newLidar]);
        generateCsv();

        dataArray.add(sData(
            now,
            distance.toString(),
            direction,
            leftSensor,
            rightSensor,
            upSensor,
            downSensor)
        );

        _time.add(now);
        _distance.add(distance.toString());
        _direction.add(direction);
        _sensor1.add(leftSensor);
        _sensor2.add(rightSensor);
        _sensor3.add(upSensor);
        _sensor4.add(downSensor);

        setState(() {
          dataArray.toSet();
          dataArray.toList();
        });
      },
        onDone: () {
          // if WebSocket is disconnected
          Fluttertoast.showToast(msg: "Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      Fluttertoast.showToast(msg: "error on connecting to websocket");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if(connected == true){
      Fluttertoast.showToast(msg: "Connected to the Websocket");
      // if(ledstatus == false && cmd != "poweron" && cmd!= "poweroff"){
      //   print("Send the valid command");
      // }else{
      //   channel.sink.add(cmd); //sending Command to NodeMCU
      // }
    }else{
      channelconnect();
      Fluttertoast.showToast(msg: "Websocket is not connected.");
    }
  }

  // system ui
  Widget buildLogoutBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => log.LoginScreen()));
        },
        padding: EdgeInsets.all(10),
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
      padding: EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          transferData(truePath);
        },
        padding: EdgeInsets.all(10),
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
          "Komori",
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
                    body: Column( //User Activity Log
                      children: [
                        SizedBox(height: 10),
                        Text(
                          log.username,
                          textAlign: TextAlign.center,
                          style: profileUserStyle,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'User ID: ${log.userId}',
                          textAlign: TextAlign.center,
                          style: profileIdStyle,
                        ),
                        SizedBox(height: 5),
                        buildUpload(),
                        Divider(
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
            Container(
              child: Center(
                child: Image.asset(
                  'assets/phone-vibrate.png',
                  width: 60,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    poggers.toString(),
                    //newData.toString(),
                    //'The sensors are detecting objects. Please wait...',
                    //'Left sensor detected object at ${sensorData} cm.',
                    style: hoverStyle,
                  ),
                  margin: const EdgeInsets.only(left: 30, right: 30, bottom: 60),
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

Future<Null>getRefresh() async{
  await Future.delayed(Duration(seconds: 3));
}

List<sData> _sensorData = <sData>[];

// create datagrid widget admin version
Widget dataGrid (BuildContext context) {
  return SfDataGrid(
    allowPullToRefresh: true,
    columnWidthMode: (dataArray.isEmpty == false)?ColumnWidthMode.auto:ColumnWidthMode.none,
    source: _sensorDataSource,
    frozenColumnsCount: 1,
    isScrollbarAlwaysShown: true,
    columns: <GridColumn>[
      GridColumn(
          columnName: 'time',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
      GridColumn(
          columnName: 'sensor1',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sensor 1',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor2',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sensor 2',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor3',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sensor 3',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor4',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sensor 4',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
    ],
    gridLinesVisibility: GridLinesVisibility.both,
    headerGridLinesVisibility: GridLinesVisibility.both,
  );
}

SensorDataSource _sensorDataSource = SensorDataSource();

class SensorDataSource extends DataGridSource{
  SensorDataSource(){
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
              alignment: (dataGridCell.columnName == 'time')? Alignment.centerRight
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
    await Future.delayed(Duration(seconds: 2));
    _addMoreRows(_sensorData, 15);
    buildDataGridRows();
    notifyListeners();
  }

  void buildDataGridRows() {
    dataGridRows = _sensorData
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'time', value: dataGridRow.time),
      DataGridCell<String>(columnName: 'distance', value: dataGridRow.distance),
      DataGridCell<String>(columnName: 'direction', value: dataGridRow.direction),
      DataGridCell<String>(columnName: 'sensor1', value: dataGridRow.sensor1),
      DataGridCell<String>(columnName: 'sensor2', value: dataGridRow.sensor2),
      DataGridCell<String>(columnName: 'sensor3', value: dataGridRow.sensor3),
      DataGridCell<String>(columnName: 'sensor4', value: dataGridRow.sensor4),
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
        _sensor1[index],
        _sensor2[index],
        _sensor3[index],
        _sensor4[index],
      ));
    }
  }
}

List<String> _time = <String>[];
List<String> _distance = <String>[];
List<String> _direction = <String>[];
List<String> _sensor1 = <String>[];
List<String> _sensor2 = <String>[];
List<String> _sensor3 = <String>[];
List<String> _sensor4 = <String>[];

class sData {
  sData(this.time, this.distance, this.direction, this.sensor1, this.sensor2, this.sensor3, this.sensor4);
  String time;
  String distance;
  String direction;
  String sensor1;
  String sensor2;
  String sensor3;
  String sensor4;
}

List<sData> getSensorData() {
  return dataArray;
}

double getDistance(double x, double y){
  return x + y;
}

String getDirection(double l, double r, double u, double d){
  var dir = '';
  if (u>d){
    dir = 'Lower ';
  } else {
    dir = 'Upper ';
  }
  if (l>r){
    dir = dir + 'Right';
  } else {
    dir = dir + 'Left';
  }
  return dir;
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

initalizeCsv() async {
  List<List<dynamic>> temp = [];
  String csvData = ListToCsvConverter().convert(temp);
  final String directory = (await getApplicationSupportDirectory()).path;
  final path = "$directory/data.csv";
  truePath = path;
  final File file = File(path);
  await file.writeAsString(csvData);
  Fluttertoast.showToast(msg: "CSV created");
}