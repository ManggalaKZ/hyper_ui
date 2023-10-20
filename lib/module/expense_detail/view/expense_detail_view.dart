import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class ExpenseDetailPage extends StatelessWidget {
  final String documentId;

  ExpenseDetailPage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('expense')
          .doc(documentId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("Expense not found");
        } else {
          var data = snapshot.data?.data() as Map<String, dynamic>;

          var name = data['name'] ?? 'null';
          var category = data['category'] ?? 'null';
          var amount = data['amount'] ?? 'null';
          var itemName = data['itemName'] ?? 'null';
          var photo = data['photo'] ?? 'null';
          var date = data['datebaru'] ?? 'null';
          String formattedDate = date != null
              ? DateFormat('dd-MMMM-yyyy').format(date.toDate())
              : "";
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Expense Details",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              padding: EdgeInsets.only(left: 15, right: 15),
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$name',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Expense Info",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Expense Name"),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Text(
                              "$name",
                              overflow: TextOverflow.visible,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Category"),
                            Text(
                              category[0].toUpperCase() +
                                  category.substring(1).toLowerCase(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Item Name"),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Text(
                              "$itemName",
                              overflow: TextOverflow.visible,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Created Date"),
                            Text(formattedDate),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Transaction Date"),
                            Text(formattedDate),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Amount"),
                            Text('$amount'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reference ID"),
                            Text(documentId),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Attachment",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image.network('$photo',
                            width: 200.0, height: 200.0, fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          print('Error: $exception');
                          return Text('-- Image Not Found --');
                        }),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Tambahkan logika penghapusan expense di sini
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Expense"),
                                    content: Text(
                                        "Are you sure you want to delete this expense?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () {
                                          // Hapus expense berdasarkan documentId
                                          FirebaseFirestore.instance
                                              .collection('expense')
                                              .doc(documentId)
                                              .delete()
                                              .then((_) {
                                            // Navigasi kembali ke layar sebelumnya
                                            Navigator.pushReplacementNamed(
                                                context, '/homeExpense');
                                          }).catchError((error) {
                                            print(
                                                "Error deleting expense: $error");
                                            // Tambahkan penanganan kesalahan jika diperlukan
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Delete Expense"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Warna latar belakang tombol
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
