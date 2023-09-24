import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/commons/style.dart';
import 'package:d_chart/ordinal/combo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class DashboardView2 extends StatefulWidget {
  DashboardView2({Key? key}) : super(key: key);
  Future<num> getTotalExpenseForCurrentUserWithCategory(String category) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUserId)
          .where("category", isEqualTo: category)
          .get();

      double totalExpense = 0.0; // Menggunakan tipe double untuk totalExpense

      for (QueryDocumentSnapshot document in expenseSnapshot.docs) {
        dynamic amount = document["amount"];
        num numericAmount =
            amount is String ? num.tryParse(amount) ?? 0 : amount ?? 0;
        totalExpense +=
            numericAmount; // Menambahkan numericAmount, bukan amount
      }

      return totalExpense;
    } else {
      // Handle kasus jika pengguna belum masuk atau tidak ada pengguna saat ini
      return 0;
    }
  }

  Widget build(context, DashboardController controller) {
    final now = DateTime.now();
    final monthFormat = DateFormat.MMMM();
    final monthName = monthFormat.format(now);
    String monthnow = monthName;
    final chartData = ChartDataModel.chartData;

    controller.view = this;
    ScrollController _scrollController = ScrollController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF9B51E0),
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              color: Color(0xFF9B51E0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Text(
                        "Welcome Back " + controller.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              Text(
                                "Spending on $monthnow 2023",
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    final totalmonthnow = chartData
                                        .where((data) =>
                                            data["month"] == "$monthnow")
                                        .toList();
                                    num total = 0;
                                    for (final data in totalmonthnow) {
                                      total += data["data"]["primer"] +
                                          data["data"]["sekunder"] +
                                          data["data"]["tersier"] +
                                          data["data"]["pendidikan"].toInt();
                                    }
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Rp.$total",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 270,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Builder(
                builder: (context) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(12.0),
                          child: ListView.builder(
                            itemCount:
                                chartData.length > 12 ? 12 : chartData.length,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final data = chartData[index];
                              return InkWell(
                                onTap: () {
                                  openChart(context);
                                },
                                child: Container(
                                  height: 100,
                                  width: 80,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: (data["data"]["primer"] +
                                                      data["data"]["sekunder"] +
                                                      data["data"]["tersier"] +
                                                      data["data"]
                                                          ["pendidikan"]) *
                                                  data["data"]["primer"] /
                                                  40000000,
                                              width: 20,
                                              color: Colors.blue,
                                            ),
                                            Container(
                                              height: (data["data"]["primer"] +
                                                      data["data"]["sekunder"] +
                                                      data["data"]["tersier"] +
                                                      data["data"]
                                                          ["pendidikan"]) *
                                                  data["data"]["sekunder"] /
                                                  40000000,
                                              width: 20,
                                              color: Colors.yellow,
                                            ),
                                            Container(
                                              height: (data["data"]["primer"] +
                                                      data["data"]["sekunder"] +
                                                      data["data"]["tersier"] +
                                                      data["data"]
                                                          ["pendidikan"]) *
                                                  data["data"]["tersier"] /
                                                  40000000,
                                              width: 20,
                                              color: Colors.red,
                                            ),
                                            Container(
                                              height: (data["data"]["primer"] +
                                                      data["data"]["sekunder"] +
                                                      data["data"]["tersier"] +
                                                      data["data"]
                                                          ["pendidikan"]) *
                                                  data["data"]["pendidikan"] /
                                                  40000000,
                                              width: 20,
                                              color: Colors.green,
                                            ),
                                          ]),
                                      SizedBox(height: 15.0),
                                      Container(
                                          height: 25,
                                          child: Text(
                                            data["month"],
                                            style: TextStyle(fontSize: 15),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Pengeluaran di Bulan $monthName",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                  height: 76.0,
                  child: ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = chartData.firstWhere(
                          (element) => element["month"] == "$monthnow");
                      List<String> kebutuhan = [
                        'Primer',
                        'Sekunder',
                        'Tersier',
                        'Pendidikan'
                      ];

                      return Row(
                        children: kebutuhan.map((jenis) {
                          return Container(
                            width: 160,
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jenis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    "${data["data"][jenis.toLowerCase()]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ExpenseItem(),
            ExpenseItem(),
            ExpenseItem(),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  @override
  State<DashboardView2> createState() => DashboardController();
}

void openChart(BuildContext context) {
  final now = DateTime.now();
  final monthFormat = DateFormat.MMMM();
  final chartData = ChartDataModel.chartData;
  final currentMonth = monthFormat.format(now);
  String monthNow = currentMonth;
  Map<String, dynamic>? monthData;
  for (final data in chartData) {
    if (data["month"] == "$monthNow") {
      monthData = data;
      break;
    }
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
              child: AspectRatio(
            aspectRatio: 16 / 9,
            child: DChartComboO(
                barLabelDecorator: BarLabelDecorator(
                    barLabelPosition: BarLabelPosition.outside),
                barLabelValue: (group, ordinalData, index) {
                  return 'Rp.${ordinalData.measure}';
                },
                outsideBarLabelStyle: (group, ordinalData, index) {
                  return const LabelStyle(
                    fontSize: 8,
                  );
                },
                groupList: [
                  OrdinalGroup(id: '1', chartType: ChartType.bar, data: [
                    OrdinalData(
                        domain: 'Primer',
                        measure: monthData!["data"]["primer"]),
                    OrdinalData(
                        domain: 'Sekunder',
                        measure: monthData["data"]["sekunder"]),
                    OrdinalData(
                        domain: 'Tersier',
                        measure: monthData["data"]["tersier"]),
                    OrdinalData(
                        domain: 'Pendidikan',
                        measure: monthData["data"]["pendidikan"]),
                  ]),
                ]),
          )),
        );
      });
}

// void openDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: Text(
//                     "Penyalahgunaan KIP-K 1",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: Text(
//                     "Are you sure to delete this report?",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey,
//                         elevation: 10,
//                       ),
//                       onPressed: () {},
//                       child: Text("Cancel"),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         elevation: 10,
//                       ),
//                       onPressed: () {},
//                       child: Text("Delete"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }
