import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/commons/style.dart';
import 'package:d_chart/ordinal/combo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  List<Map<String, dynamic>> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUser?.uid)
          .get();

      List<Map<String, dynamic>> data = [
        {
          "month": "January",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "February",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "March",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "April",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "May",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "June",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "July",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "August",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "September",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "October",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "November",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
        {
          "month": "December",
          "data": {"primer": 0, "sekunder": 0, "tersier": 0, "pendidikan": 0}
        },
      ];

      querySnapshot.docs.forEach((document) {
        String month = document['bulan'];
        num amount = document['amount'];
        String category = document['category'];

        int existingIndex = data.indexWhere((entry) => entry['month'] == month);

        if (existingIndex != -1) {
          if (category == "primer") {
            data[existingIndex]['data']['primer'] += amount;
          } else if (category == "sekunder") {
            data[existingIndex]['data']['sekunder'] += amount;
          } else if (category == "tersier") {
            data[existingIndex]['data']['tersier'] += amount;
          } else if (category == "pendidikan") {
            data[existingIndex]['data']['pendidikan'] += amount;
          }
        } else {
          Map<String, dynamic> newData = {
            'month': month,
            'data': {
              'primer': category == "primer" ? amount : 0,
              'sekunder': category == "sekunder" ? amount : 0,
              'tersier': category == "tersier" ? amount : 0,
              'pendidikan': category == "pendidikan" ? amount : 0,
            },
          };
          data.add(newData);
        }
      });

      setState(() {
        chartData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: chartData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final data = chartData[index];
                    final totalData = data["data"]["primer"] +
                        data["data"]["sekunder"] +
                        data["data"]["tersier"] +
                        data["data"]["pendidikan"];
                    double maxHeight = 190.0;

                    return InkWell(
                      onTap: () {
                        showDetail(data);
                      },
                      child: Container(
                        height: 100,
                        width: 80,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (totalData > 0)
                              Stack(
                                // Grafik
                                alignment: Alignment.centerLeft,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: min(
                                            (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["primer"] /
                                                12000000000,
                                            maxHeight),
                                        width: 20,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        height: min(
                                            (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["sekunder"] /
                                                12000000000,
                                            maxHeight),
                                        width: 20,
                                        color: Colors.yellow,
                                      ),
                                      Container(
                                        height: min(
                                            (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["tersier"] /
                                                12000000000,
                                            maxHeight),
                                        width: 20,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        height: min(
                                            (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["pendidikan"] /
                                                12000000000,
                                            maxHeight),
                                        width: 20,
                                        color: Colors.green,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            else if (totalData == 0)
                              Stack(
                                // Grafik
                                alignment: Alignment.centerLeft,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 20,
                                        color: Colors.grey[300],
                                      ),
                                      Container(
                                        height: 80,
                                        width: 20,
                                        color: Colors.grey[400],
                                      ),
                                      Container(
                                        height: 90,
                                        width: 20,
                                        color: Colors.grey[350],
                                      ),
                                      Container(
                                        height: 110,
                                        width: 20,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 25,
                              child: Text(
                                data["month"],
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDetail(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detail Data - ${data['month']}"),
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: DChartComboO(
                        barLabelDecorator: BarLabelDecorator(
                            barLabelPosition: BarLabelPosition.outside),
                        barLabelValue: (group, ordinalData, index) {
                          return '${ordinalData.measure}';
                        },
                        outsideBarLabelStyle: (group, ordinalData, index) {
                          return const LabelStyle(
                            fontSize: 8,
                          );
                        },
                        groupList: [
                          OrdinalGroup(
                              id: '1',
                              chartType: ChartType.bar,
                              data: [
                                OrdinalData(
                                    other: SizedBox(width: 10),
                                    domain: 'Primer',
                                    measure: data['data']['primer']),
                                OrdinalData(
                                    other: SizedBox(width: 10),
                                    domain: 'Sekunder',
                                    measure: data['data']['sekunder']),
                                OrdinalData(
                                    other: SizedBox(width: 10),
                                    domain: 'Tersier',
                                    measure: data['data']['tersier']),
                                OrdinalData(
                                    other: SizedBox(width: 10),
                                    domain: 'Pendidikan',
                                    measure: data['data']['pendidikan']),
                              ]),
                        ]),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 30,
                          width: 80,
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
