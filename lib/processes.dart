import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mysql.dart';

// Transfer of data from csv
// Connection of flutter to microcontroller
List<List<dynamic>> newData =[];
// initialize database
var db = Mysql();
var poggers;

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

Future<List<List<dynamic>>> loadCsvData(String path) async {
  final csvFile = new File(path).openRead();
  return await csvFile
      .transform(utf8.decoder)
      .transform(
    CsvToListConverter(),
  )
      .toList();
}

// ["UserID", "Time", "Distance", "Direction", "Sensor1", "Sensor2", "Sensor3", "Sensor4", "LiDAR"]
transferData(String path) async {
  newData = await loadCsvData(path);
  db.getConnection().then((conn){
    for (var row in newData){
      poggers = row;
      var userId = row[0];
      var time = row[1];
      var distance = row[2];
      var direction = row[3];
      var leftU = row[4];
      var rightU = row[5];
      var upU = row[6];
      var downU = row[7];
      var lidar = row[8];


      String sql = 'INSERT INTO Guidance_system.sensors (user_id, time, distance, direction, leftUltrasonic, rightUltrasonic, upUltrasonic, downUltrasonic, lidar) VALUES ($userId, "$time", $distance, "$direction", $leftU, $rightU, $upU, $downU, $lidar);';
      conn.query(sql);

    }
    Fluttertoast.showToast(msg: "Data uploaded!");
    conn.close();
  });
}


// bool checker(int user,String time) {
//   bool exist = true;
//   db.getConnection().then((conn){
//     String sql = 'SELECT activity_id FROM Guidance_system.sensors WHERE user_id=$user AND time=$time;';
//     conn.query(sql).then((results) {
//       var check = results.toList();
//       // if check is empty, there are no duplicates
//       if (check.isEmpty) {
//         exist = true;
//       } else {
//         exist = false;
//       }
//     });
//     conn.close();
//   });
//   return exist;
// }



