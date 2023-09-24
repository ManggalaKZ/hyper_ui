import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({Key? key}) : super(key: key);

  Future<List<DocumentSnapshot>> getExpenseDataByCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUserId)
          .get();

      return expenseSnapshot.docs;
    } else {
      return [];
    }
  }

  Widget build(context, ExpenseListController controller) {
    controller.view = this;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<DocumentSnapshot>>(
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
                List<DocumentSnapshot> expenseDocuments = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: expenseDocuments.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = expenseDocuments[index];

                    String date = document["datebaru"];
                    String name = document["name"];
                    String category = document["category"];
                    num amount = document["amount"];
                    String itemName = document["itemName"];
                    String photo = document["photo"];

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenseDetailPage(
                                  documentId: document.id,
                                )),
                      ),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(
                              photo,
                            ),
                          ),
                          title: Text(name),
                          subtitle: Text(date),
                          trailing: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  "Rp." + amount.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
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
        ],
      ),
    );
  }

  @override
  State<ExpenseListView> createState() => ExpenseListController();
}
