import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'styles.dart';
import 'mysql.dart';
import 'loginScreen.dart' as log;

var index = 0;
List<sData> dataArray = [];
var db = Mysql();

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState(){
    _sensorData = getSensorData();
  }

  Widget buildLogoutBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 150),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () => print("Logout pressed"),
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green.shade900,
        child: Text(
          'Logout',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tahoma'
          ),
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
          'Users Data',
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
  }
}

Future<Null>getRefresh() async{
  await Future.delayed(Duration(seconds: 3));
}

List<sData> _sensorData = <sData>[];

Widget dataGrid (BuildContext context) {
  return SfDataGrid(
    allowPullToRefresh: true,
    columnWidthMode: (dataArray.isEmpty == false)?ColumnWidthMode.auto:ColumnWidthMode.none,
    source: _sensorDataSource,
    frozenColumnsCount: 1,
    isScrollbarAlwaysShown: true,
    columns: <GridColumn>[
      GridColumn(
          columnName: 'user_id',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'User',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
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
                'Left Sensor',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor2',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Right Sensor',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor3',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Up Sensor',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'sensor4',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Down Sensor',
                style: dataGridHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'lidar',
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'LiDAR',
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
              alignment: (dataGridCell.columnName == 'user_id')? Alignment.centerRight
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
    retrieveData();
    dataGridRows = _sensorData
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'user_id', value: dataGridRow.user_id),
      DataGridCell<String>(columnName: 'time', value: dataGridRow.time),
      DataGridCell<String>(columnName: 'distance', value: dataGridRow.distance),
      DataGridCell<String>(columnName: 'direction', value: dataGridRow.direction),
      DataGridCell<String>(columnName: 'sensor1', value: dataGridRow.sensor1),
      DataGridCell<String>(columnName: 'sensor2', value: dataGridRow.sensor2),
      DataGridCell<String>(columnName: 'sensor3', value: dataGridRow.sensor3),
      DataGridCell<String>(columnName: 'sensor4', value: dataGridRow.sensor4),
      DataGridCell<String>(columnName: 'lidar', value: dataGridRow.lidar),
    ]))
        .toList();
  }

  void _addMoreRows(List<sData> sensorData, int count) {
    final startIndex = sensorData.isNotEmpty ? sensorData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      sensorData.add(sData(
        _userid[index],
        _time[index],
        _distance[index],
        _direction[index],
        _sensor1[index],
        _sensor2[index],
        _sensor3[index],
        _sensor4[index],
        _lidar[index],
      ));
    }
  }
}

List<String> _userid = <String>[];
List<String> _time = <String>[];
List<String> _distance = <String>[];
List<String> _direction = <String>[];
List<String> _sensor1 = <String>[];
List<String> _sensor2 = <String>[];
List<String> _sensor3 = <String>[];
List<String> _sensor4 = <String>[];
List<String> _lidar = <String>[];

class sData {
  sData(this.user_id, this.time, this.distance, this.direction, this.sensor1, this.sensor2, this.sensor3, this.sensor4, this.lidar);
  String user_id;
  String time;
  String distance;
  String direction;
  String sensor1;
  String sensor2;
  String sensor3;
  String sensor4;
  String lidar;
}

List<sData> getSensorData() {
  return dataArray;
}

// get data from database
void retrieveData() async{
  Fluttertoast.showToast(msg: "Retrieving data...");
  db.getConnection().then((conn) {
    String sql = 'SELECT user_id, time, distance, direction, leftUltrasonic, rightUltrasonic, upUltrasonic, downUltrasonic, lidar FROM Guidance_system.sensors;';
    conn.query(sql).then((results) {
      var sensData = results.toList();
      var size = sensData.length;
      for(var i = 0; i<size; i++){
        var userId = sensData[i][0].toString();
        var time = sensData[i][1].toString();
        var date = DateTime.parse(time);
        var formattedDate = DateFormat.Hms().format(date);
        var distance = sensData[i][2].toString();
        var direction = sensData[i][3].toString();
        var leftU = sensData[i][4].toString();
        var rightU = sensData[i][5].toString();
        var upU = sensData[i][6].toString();
        var downU = sensData[i][7].toString();
        var lidar = sensData[i][8].toString();

        dataArray.add(sData(
            userId,
            formattedDate,
            distance,
            direction,
            leftU,
            rightU,
            upU,
            downU,
            lidar)
        );

        _userid.add(userId);
        _time.add(formattedDate);
        _distance.add(distance);
        _direction.add(direction);
        _sensor1.add(leftU);
        _sensor2.add(rightU);
        _sensor3.add(upU);
        _sensor4.add(downU);
        _lidar.add(lidar);

        // setState(() {
        //   dataArray.toSet();
        //   dataArray.toList();
        // });
      }
    });
    conn.close();
  });
  Fluttertoast.showToast(msg: "Data received done");
}

