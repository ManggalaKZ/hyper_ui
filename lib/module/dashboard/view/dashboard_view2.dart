import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class DashboardView2 extends StatefulWidget {
  Future<List<DocumentSnapshot>> getExpenseDataByCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUserId)
          .orderBy("date", descending: true)
          .get();

      return expenseSnapshot.docs;
    } else {
      return [];
    }
  }

  final double totalAmount;
  DashboardView2({Key? key, this.totalAmount = 0.0}) : super(key: key);

  Future<Map<String, int>> getTotalExpenseByCategory() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      Map<String, int> categoryTotals = {};

      DateTime now = DateTime.now();
      String currentMonth = DateFormat('MMMM').format(now);

      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUserId)
          .orderBy("date", descending: true)
          .get();

      expenseSnapshot.docs.forEach((doc) {
        String category = doc['category'];
        int expenseAmount = doc['amount'];
        String month = doc['bulan'];

        if (month == currentMonth) {
          // Memeriksa apakah kategori sudah ada dalam categoryTotals
          if (month == currentMonth) {
            categoryTotals[category] =
                (categoryTotals[category] ?? 0) + expenseAmount;
          } else {
            categoryTotals[category] = expenseAmount;
          }
        }
      });

      return categoryTotals;
    } else {
      return {};
    }
  }

  late final Future<Map<String, int>> _categoryTotals =
      getTotalExpenseByCategory();

  Widget build(context, DashboardController controller) {
    final now = DateTime.now();
    final monthFormat = DateFormat.MMMM();
    final monthName = monthFormat.format(now);
    String monthnow = monthName;

    controller.view = this;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF9B51E0),
        title: const Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<Map<String, int>>(
        future: _categoryTotals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SingleChildScrollView(
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
                                        "Rp.0",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
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
                            List<String> kebutuhan = [
                              'Primer',
                              'Sekunder',
                              'Tersier',
                              'Pendidikan'
                            ];

                            return Row(children: [
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[0],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        "0",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[1],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        "0",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[2],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        "0",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[3],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        "0",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]);
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
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
                                      child: ListView.builder(
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          // Membuat variabel total
                                          int overallTotal = 0;
                                          // Mengakses data dari snapshot
                                          final categoryTotals = snapshot.data;
                                          // Melakukan penjumlahan
                                          if (categoryTotals != null) {
                                            categoryTotals
                                                .forEach((category, total) {
                                              overallTotal += total;
                                            });
                                          }
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Rp.$overallTotal",
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
                            List<String> kebutuhan = [
                              'Primer',
                              'Sekunder',
                              'Tersier',
                              'Pendidikan'
                            ];
                            final primer = 'primer';
                            final totPrimer = snapshot.data?[primer] ?? 0;
                            final sekunder = 'sekunder';
                            final totSekunder = snapshot.data?[sekunder] ?? 0;
                            final tersier = 'tersier';
                            final totTersier = snapshot.data?[tersier] ?? 0;
                            final pendidikan = 'pendidikan';
                            final totPendidikan =
                                snapshot.data?[pendidikan] ?? 0;

                            return Row(children: [
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[0],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        totPrimer.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[1],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        totSekunder.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[2],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        totTersier.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kebutuhan[3],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        totPendidikan.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]);
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 315,
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: getExpenseDataByCurrentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          List<DocumentSnapshot> expenseDocuments =
                              snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: expenseDocuments.length > 3
                                ? 3
                                : expenseDocuments.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  expenseDocuments[index];
                              Timestamp? date = document["datebaru"];
                              String formattedDate = date != null
                                  ? DateFormat('dd MMMM yyyy')
                                      .format(date.toDate())
                                  : "";
                              String name = document["name"];
                              String category = document["category"];
                              String photo = document["photo"];
                              num amount = document["amount"];

                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpenseDetailPage(
                                      documentId: document.id,
                                    ),
                                  ),
                                ),
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: NetworkImage(photo),
                                    ),
                                    title: Text(
                                      name,
                                    ),
                                    subtitle: Text(formattedDate),
                                    trailing: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            category[0].toUpperCase() +
                                                category
                                                    .substring(1)
                                                    .toLowerCase(),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xFF9B51E0)),
                                          ),
                                          Text(
                                            "Rp." + amount.toString(),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      )),
    );
  }

  @override
  State<DashboardView2> createState() => DashboardController();
}
