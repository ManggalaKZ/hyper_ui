import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
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

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF9B51E0),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Expense"),
      ),
      body: Stack(
        children: [
          Container(
              child: Column(
            children: [
              searchBox(),
              Expanded(
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: getExpenseDataByCurrentUser(),
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
                      List<DocumentSnapshot> expenseDocuments =
                          snapshot.data ?? [];
                      if (searchText.isNotEmpty) {
                        expenseDocuments = expenseDocuments.where((document) {
                          var name = document["name"] ?? '';
                          return name
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
                      if (expenseDocuments.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFF9B51E0),
                                    size: 70,
                                  )),
                            ),
                            Text(
                              "Data masih kosong!",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: expenseDocuments.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = expenseDocuments[index];
                          Timestamp? date = document["datebaru"];
                          String formattedDate = date != null
                              ? DateFormat('dd MMMM yyyy').format(date.toDate())
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        category[0].toUpperCase() +
                                            category.substring(1).toLowerCase(),
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
              SizedBox(
                height: 60,
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    margin: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => AddExpensePageView(),
                        ))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9B51E0),
                        elevation: 10,
                      ),
                      child: const Text(
                        'Add new expense',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: 'Search expense...',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
