import 'package:flutter/material.dart';
import 'package:flutter/src/material/divider.dart';
import 'loginScreen.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'styles.dart';


// declare global variables
var sensorData = '1';
List<sData> dataArray = [];
var index = 0;
final now = DateTime.now();
var dirX, dirY;

final FlutterTts tts = FlutterTts();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  // get sensor data
  // late bool ledstatus; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  late bool connected; //boolean value to track if WebSocket is connected

  @override
  void initState() {
    super.initState();
    _sensorData = getSensorData();
    //ledstatus = false; //initially ledstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero,() async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();

  }

  @override
  void dispose(){
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  channelconnect(){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        sensorData = message;

        // separating received sensor data

        final splitted = sensorData.split(',');
        var leftSensor = splitted[0];
        var rightSensor = splitted[1];
        var upSensor = splitted[2];
        var downSensor = splitted[3];


        var newLeft = double.parse(leftSensor);
        var newRight = double.parse(rightSensor);
        var newUp = double.parse(upSensor);
        var newDown = double.parse(downSensor);



        // if (newLeft > newRight){
        //   tts.speak("Object detected on the left");
        // } else {
        //   tts.speak("Object detected on the right");
        // }

        // determining direction of object
        // one algo to determine X location (left, mid, right)
        // one algo to determine Y location (up, front, down)





        dataArray.add(sData(now.toString(),leftSensor,rightSensor));
        _time.add(now.toString());
        _sensor1.add(leftSensor);
        _sensor2.add(rightSensor);

        setState(() {
          dataArray.toSet();
          dataArray.toList();
        });
      },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);

    }catch (_){
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if(connected == true){
      // if(ledstatus == false && cmd != "poweron" && cmd!= "poweroff"){
      //   print("Send the valid command");
      // }else{
      //   channel.sink.add(cmd); //sending Command to NodeMCU
      // }
    }else{
      channelconnect();
      print("Websocket is not connected.");
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          "App Name",
          style: TextStyle(
            fontFamily: 'Bebas Neue',
            fontSize: 25,
          ),
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
                        style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      backgroundColor: Colors.green.shade900,
                    ),
                    body: Column( //User Activity Log
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Blind guy',
                          textAlign: TextAlign.center,
                          style: profileUserStyle,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'User #: 0000001',
                          textAlign: TextAlign.center,
                          style: profileIdStyle,
                        ),
                        SizedBox(height: 5),
                        buildLogoutBtn(),
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
                    //'The sensors are detecting objects. Please wait...',
                    'Left sensor detected object at ${sensorData} cm.',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                    ),
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

// create datagrid widget
Widget dataGrid (BuildContext context) {
  return SfDataGrid(
    allowPullToRefresh: true,
    columnWidthMode: (dataArray.isEmpty == false)?ColumnWidthMode.auto:ColumnWidthMode.fill,
    source: _sensorDataSource,
    frozenColumnsCount: 1,
    columns: <GridColumn>[
      GridColumn(
          columnName: 'time',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                'Time',
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
      DataGridCell<String>(columnName: 'sensor1', value: dataGridRow.sensor1),
      DataGridCell<String>(columnName: 'sensor1', value: dataGridRow.sensor2),
    ]))
        .toList();
  }

  void _addMoreRows(List<sData> sensorData, int count) {
    final startIndex = sensorData.isNotEmpty ? sensorData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      sensorData.add(sData(
        _time[index],
        _sensor1[index],
        _sensor2[index],
      ));
    }
  }
}

List<String> _time = <String>[];

List<String> _sensor1 = <String>[];

List<String> _sensor2 = <String>[];

class sData {
  sData(this.time, this.sensor1, this.sensor2);
  String time;
  String sensor1;
  String sensor2;
}

List<sData> getSensorData() {
  return dataArray;
}
