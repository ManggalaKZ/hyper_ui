import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/module/dashboard/view/diagram.dart';

class DashboardView2 extends StatefulWidget {
  final double totalAmount;
  DashboardView2({Key? key, this.totalAmount = 0.0}) : super(key: key);

  Future<List<DocumentSnapshot>> getExpense() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    final monthFormat = DateFormat.MMMM();
    final monthName = monthFormat.format(now);
    String monthnow = monthName;
    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      List<String> categoriesToSum = [
        'primer',
        'sekunder',
        'tersier',
        'pendidikan'
      ];
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUserId)
          .where("bulan", isEqualTo: monthnow)
          .get();

      return expenseSnapshot.docs;
    } else {
      return [];
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<List<DocumentSnapshot>>(
        future: getExpense(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<DocumentSnapshot> expenseDocuments = snapshot.data ?? [];
            num totalAmount = 0;

            expenseDocuments.forEach((document) {
              num amount = document["amount"];
              totalAmount += amount;
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...expenseDocuments.map((document) {
                  num amount = document["amount"];
                  String bulan = document["bulan"];
                  String category = document["category"];

                  return Column(
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
                              child: Container(child: Text("Welcome back ")),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
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
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Rp.$totalAmount",
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                      YourWidget(),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                final data = chartData.firstWhere((element) =>
                                    element["month"] == "$monthnow");
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                  );
                }),
              ],
            );
          }
        },
      )),
    );
  }

  @override
  State<DashboardView2> createState() => DashboardController();
}
