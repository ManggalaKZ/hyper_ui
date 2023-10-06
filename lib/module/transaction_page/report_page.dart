import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future<List<DocumentSnapshot>> getReportDataByCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      QuerySnapshot reportSnapshot = await FirebaseFirestore.instance
          .collection("report")
          .where("user.uid", isEqualTo: currentUserId)
          .get();

      return reportSnapshot.docs;
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
        title: const Text("Report"),
      ),
      body: Stack(
        children: [
          Container(
              child: Column(
            children: [
              searchBox(),
              Expanded(
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: getReportDataByCurrentUser(),
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
                      List<DocumentSnapshot> reportDocuments =
                          snapshot.data ?? [];

                      // Filter data berdasarkan teks pencarian
                      if (searchText.isNotEmpty) {
                        reportDocuments = reportDocuments.where((document) {
                          var name = document["reportName"] ?? '';
                          return name
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }

                      if (reportDocuments.isEmpty) {
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
                        itemCount: reportDocuments.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = reportDocuments[index];
                          Timestamp? date = document["date"];
                          String formattedDate = date != null
                              ? DateFormat('dd MMMM yyyy').format(date.toDate())
                              : "";
                          String reportName = document["reportName"];

                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportDetailView(
                                  documentId: document.id,
                                ),
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(reportName),
                                subtitle: Text(formattedDate),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 1),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditReportView(
                                              documentId: document.id,
                                            ),
                                          ))
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 1),
                                        onPressed: () {
                                          openDialog(document);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        )),
                                  ],
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
                          builder: (context) => AddReportView(),
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
                        'Add new report',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openDialog(DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      document["reportName"],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Are you sure to delete this report?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          elevation: 10,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 10,
                        ),
                        onPressed: () {
                          deleteReport(document.id);
                          Navigator.pushReplacementNamed(
                              context, '/homeReport');
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteReport(String documentId) {
    // Tambahkan logika penghapusan data berdasarkan documentId
    FirebaseFirestore.instance.collection("report").doc(documentId).delete();
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
            hintText: 'Search report...',
            hintStyle: TextStyle(
              color: Colors.grey,
            )),
      ),
    );
  }
}
