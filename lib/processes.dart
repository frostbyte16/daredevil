import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mysql.dart';
import 'homeScreen.dart';

// Transfer of data from csv
// Connection of flutter to microcontroller
List<List<dynamic>> newData = [];
// initialize database
var db = Mysql();
var poggers;

double getDistance(double x, double y) {
  return x + y;
}

String getDirection(double l, double r, double m, double d) {
  var dir = '';
  // will change upon further testing
  // if (m > m) {
  //   dir = 'Lower ';
  // } else {
  //   dir = 'Upper ';
  // }
  if (d <= 100) {
    dir = 'Near ';
    if (m >= 0 && m <= 40) {
      dir = dir + 'Upper ';
    } else if (m > 40 && m <= 100) {
      dir = dir + 'Lower ';
    }
  } else if (d > 100 && d <= 400) {
    dir = 'Far ';
    if (m > 100 && m <= 120) {
      dir = dir + 'Upper ';
    } else if (m > 120 && m <= 400) {
      dir = dir + 'Lower ';
    }
  }

  if (l >= 0 && l <= 200 && r >= 0 && r <= 200) {
    dir = dir + 'Middle';
  } else if (r >= 0 && r <= 200) {
    dir = dir + 'Right';
  } else if (l >= 0 && l <= 200) {
    dir = dir + 'Left';
  }

  return dir;
}

Future<List<List<dynamic>>> loadCsvData(String path) async {
  final csvFile = File(path).openRead();
  return await csvFile
      .transform(utf8.decoder)
      .transform(
        const CsvToListConverter(),
      )
      .toList();
}

// ["UserID", "Time", "Distance", "Direction", "Sensor1", "Sensor2", "Sensor3", "Sensor4", "LiDAR"]
transferData(String path) async {
  Fluttertoast.showToast(msg: "Uploading data...");
  newData = await loadCsvData(path);
  db.getConnection().then((conn) {
    for (var row in newData) {
      poggers = row;
      var userId = row[0];
      var time = row[1];
      var distance = row[2];
      var direction = row[3];
      var leftU = row[4];
      var rightU = row[5];
      var upU = row[6];
      var lidar = row[7];

      // bool noDuplicates = await checker(userId, time);
      // if(noDuplicates==true){
      //   String sql = 'INSERT INTO Guidance_system.sensors (user_id, time, distance, direction, leftUltrasonic, rightUltrasonic, midUltrasonic, downUltrasonic, lidar) VALUES ($userId, "$time", $distance, "$direction", $leftU, $rightU, $upU, $downU, $lidar);';
      //   conn.query(sql);
      // }

      String sql =
          'INSERT INTO Guidance_system.sensors (user_id, time, distance, direction, leftUltrasonic, rightUltrasonic, midUltrasonic, lidar) VALUES ($userId, "$time", $distance, "$direction", $leftU, $rightU, $upU, $lidar);';
      conn.query(sql);
      Fluttertoast.showToast(msg: sql);
    }
    conn.close();
  });
  Fluttertoast.showToast(msg: "Data uploaded!");
  initializeCsv();
}

// bool exist = false;
//
// Future<bool> checker(int user,String time) async {
//   db.getConnection().then((conn){
//     String sql = 'SELECT activity_id FROM Guidance_system.sensors WHERE user_id=$user AND time="$time";';
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



