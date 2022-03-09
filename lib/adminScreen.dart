import 'package:flutter/material.dart';
import 'package:flutter/src/material/divider.dart';
import 'package:flutter/src/material/data_table.dart';
import 'loginScreen.dart';

class AdminScreen extends StatefulWidget {

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  Widget buildLogoutBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 150),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Users Data (Admin)',
          style: TextStyle(
            fontFamily: 'Bebas Neue',
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.green.shade900,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            buildLogoutBtn(),
            const Divider(
              height: 25,
              color: Colors.white,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'USER',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'LiDAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TIME',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TYPE',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00001',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '2cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '07:02:55',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00001',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '6cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '09:40:31',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00002',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10.2cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '09:41:12',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Error',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '00003',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '14.92cm',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '10:06:22',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Success',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tahoma',
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
